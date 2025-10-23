module TopModule(
    input        clk,
    input        reset,
    input  [2:0] s,
    output reg   fr2,
    output reg   fr1,
    output reg   fr0,
    output reg   dfr
);

    // Define water level states as parameters for clarity
    localparam [1:0]
        BELOW_S0  = 2'd0,
        BETWEEN_S1_S0 = 2'd1,
        BETWEEN_S2_S1 = 2'd2,
        ABOVE_S2  = 2'd3;

    reg [2:0] prev_s;
    reg [1:0] prev_level;

    // Function to decode sensor pattern to water level state
    // Invalid patterns map to BELOW_S0 to ensure safe max flow
    function [1:0] decode_level;
        input [2:0] sensors;
        begin
            case (sensors)
                3'b111: decode_level = ABOVE_S2;          // Above s[2]
                3'b011: decode_level = BETWEEN_S2_S1;    // Between s[2] and s[1]
                3'b001: decode_level = BETWEEN_S1_S0;    // Between s[1] and s[0]
                3'b000: decode_level = BELOW_S0;          // Below s[0]
                default: decode_level = BELOW_S0;          // Treat invalid as BELOW_S0
            endcase
        end
    endfunction

    wire [1:0] curr_level = decode_level(s);

    // Track previous sensor pattern and water level synchronously
    always @(posedge clk) begin
        if (reset) begin
            prev_s     <= 3'b000;       // No sensors asserted on reset
            prev_level <= BELOW_S0;     // Lowest water level on reset
            // On reset also assert all outputs to match "below s[0]" condition
            fr0 <= 1'b1;
            fr1 <= 1'b1;
            fr2 <= 1'b1;
            dfr <= 1'b1;
        end else begin
            prev_s     <= s;
            prev_level <= curr_level;

            // Nominal flow outputs combinationally assigned by current water level
            case (curr_level)
                ABOVE_S2: begin
                    // Above s[2]: no nominal flow (fr2=0, fr1=0, fr0=0)
                    fr0 <= 1'b0;
                    fr1 <= 1'b0;
                    fr2 <= 1'b0;
                end
                BETWEEN_S2_S1: begin
                    // Between s[2] and s[1]: fr0 only
                    fr0 <= 1'b1;
                    fr1 <= 1'b0;
                    fr2 <= 1'b0;
                end
                BETWEEN_S1_S0: begin
                    // Between s[1] and s[0]: fr0, fr1
                    fr0 <= 1'b1;
                    fr1 <= 1'b1;
                    fr2 <= 1'b0;
                end
                BELOW_S0: begin
                    // Below s[0]: fr0, fr1, fr2
                    fr0 <= 1'b1;
                    fr1 <= 1'b1;
                    fr2 <= 1'b1;
                end
                default: begin
                    // Safety fallback: assert all flows
                    fr0 <= 1'b1;
                    fr1 <= 1'b1;
                    fr2 <= 1'b1;
                end
            endcase

            // Supplemental flow valve dfr asserted if water level has risen
            dfr <= (curr_level > prev_level);
        end
    end

endmodule