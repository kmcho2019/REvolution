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

    // Registers for storing state
    reg [1:0] current_level;
    reg [1:0] prev_level_before_change;
    reg [2:0] prev_s;

    // Decode sensors to water level (deterministic for all 3-bit inputs)
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
            // Reset all states to "below s0" (lowest level)
            current_level          <= BELOW_S0;
            prev_level_before_change <= BELOW_S0;
            prev_s                 <= 3'b000;
            dfr                    <= 1'b1; // as per spec: outputs all asserted at reset
        end else begin
            // Detect sensor input change
            if (s != prev_s) begin
                // On sensor change, update prev_level_before_change with current_level before changing it
                prev_level_before_change <= current_level;
                prev_s <= s;
            end

            // Update current level from decoded sensors synchronously
            current_level <= decoded_level;

            // Set dfr if current_level > prev_level_before_change (level rose compared to before last sensor change)
            dfr <= (decoded_level > prev_level_before_change);
        end
    end

    // Combinational outputs for nominal flow valves (fr2, fr1, fr0)
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