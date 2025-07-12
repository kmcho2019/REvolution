module TopModule (
    input        clk,
    input        reset,
    input  [2:0] s,
    output reg   fr2,
    output reg   fr1,
    output reg   fr0,
    output reg   dfr
);

    // Water level encoding
    localparam BELOW_S0      = 2'd0;
    localparam BETWEEN_S1_S0 = 2'd1;
    localparam BETWEEN_S2_S1 = 2'd2;
    localparam ABOVE_S2      = 2'd3;

    reg [1:0] prev_stable_level;  // Previous stable level before last sensor change
    reg [1:0] current_level;       // Current decoded water level

    // Decode sensors to water level deterministically for all 3-bit inputs:
    // Priority: all sensors asserted => ABOVE_S2
    // s == 3'b111: ABOVE_S2
    // s == 3'b011: BETWEEN_S2_S1
    // s == 3'b001: BETWEEN_S1_S0
    // s == 3'b000: BELOW_S0
    // else fallback mapping:
    // if s[0] == 1 -> BETWEEN_S1_S0
    // else if s[1] == 1 -> BETWEEN_S2_S1
    // else if s[2] == 1 -> ABOVE_S2
    // else BELOW_S0
    wire [1:0] decoded_level;
    assign decoded_level =
        (s == 3'b111) ? ABOVE_S2 :
        (s == 3'b011) ? BETWEEN_S2_S1 :
        (s == 3'b001) ? BETWEEN_S1_S0 :
        (s == 3'b000) ? BELOW_S0 :
        (s[0] == 1'b1) ? BETWEEN_S1_S0 :
        (s[1] == 1'b1) ? BETWEEN_S2_S1 :
        (s[2] == 1'b1) ? ABOVE_S2 :
        BELOW_S0;

    always @(posedge clk) begin
        if (reset) begin
            // Reset to low water level sustained state:
            prev_stable_level <= BELOW_S0;
            current_level     <= BELOW_S0;
            dfr               <= 1'b1;  // dfr asserted at reset as per spec
        end else begin
            if (decoded_level != current_level) begin
                // Sensor level changed, update prev_stable_level before last change
                prev_stable_level <= current_level;
                current_level     <= decoded_level;
            end
            // dfr is high if water level rose compared to previous stable level
            dfr <= (decoded_level > prev_stable_level);
        end
    end

    // fr outputs combinational from current_level per spec:
    // BELOW_S0: fr0=1, fr1=1, fr2=1
    // BETWEEN_S1_S0: fr0=1, fr1=1, fr2=0
    // BETWEEN_S2_S1: fr0=1, fr1=0, fr2=0
    // ABOVE_S2: fr0=0, fr1=0, fr2=0
    always @(*) begin
        case (current_level)
            BELOW_S0: begin
                fr2 = 1'b1;
                fr1 = 1'b1;
                fr0 = 1'b1;
            end
            BETWEEN_S1_S0: begin
                fr2 = 1'b0;
                fr1 = 1'b1;
                fr0 = 1'b1;
            end
            BETWEEN_S2_S1: begin
                fr2 = 1'b0;
                fr1 = 1'b0;
                fr0 = 1'b1;
            end
            ABOVE_S2: begin
                fr2 = 1'b0;
                fr1 = 1'b0;
                fr0 = 1'b0;
            end
            default: begin
                fr2 = 1'b1;
                fr1 = 1'b1;
                fr0 = 1'b1;
            end
        endcase
    end

endmodule