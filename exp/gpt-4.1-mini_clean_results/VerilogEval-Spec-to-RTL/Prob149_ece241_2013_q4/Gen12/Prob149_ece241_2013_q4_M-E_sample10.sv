module TopModule (
    input        clk,
    input        reset,
    input  [2:0] s,
    output reg   fr2,
    output reg   fr1,
    output reg   fr0,
    output reg   dfr
);

    // Water level states encoding
    localparam BELOW_S0      = 2'd0;
    localparam BETWEEN_S1_S0 = 2'd1;
    localparam BETWEEN_S2_S1 = 2'd2;
    localparam ABOVE_S2      = 2'd3;

    // Function to decode sensors to water level state
    function [1:0] decode_level;
        input [2:0] sensors;
        begin
            // According to spec:
            // Above s[2]: s = 3'b111 -> ABOVE_S2
            // Between s[2] and s[1]: s = 3'b011 -> BETWEEN_S2_S1
            // Between s[1] and s[0]: s = 3'b001 -> BETWEEN_S1_S0
            // Below s[0]: s = 3'b000 -> BELOW_S0
            // Also for other intermediate values, fallback based on highest asserted sensor:

            if (sensors == 3'b111)
                decode_level = ABOVE_S2;
            else if (sensors[2] == 1'b1)
                decode_level = ABOVE_S2;
            else if (sensors == 3'b011)
                decode_level = BETWEEN_S2_S1;
            else if (sensors[1] == 1'b1)
                decode_level = BETWEEN_S2_S1;
            else if (sensors == 3'b001)
                decode_level = BETWEEN_S1_S0;
            else if (sensors[0] == 1'b1)
                decode_level = BETWEEN_S1_S0;
            else
                decode_level = BELOW_S0;
        end
    endfunction

    reg [1:0] current_level;
    reg [1:0] prev_level;

    always @(posedge clk) begin
        if (reset) begin
            current_level <= BELOW_S0;
            prev_level    <= BELOW_S0;
            // At reset all outputs asserted as per spec
            fr2 <= 1'b1;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
            dfr <= 1'b1;
        end else begin
            // Update previous level first
            prev_level <= current_level;
            // Decode current sensors to level
            current_level <= decode_level(s);

            // fr* outputs combinationally assigned below in always block

            // dfr is set if current water level > previous water level (rising water level)
            dfr <= (decode_level(s) > prev_level);
        end
    end

    // Combinational logic for nominal flow valves based on current_level
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