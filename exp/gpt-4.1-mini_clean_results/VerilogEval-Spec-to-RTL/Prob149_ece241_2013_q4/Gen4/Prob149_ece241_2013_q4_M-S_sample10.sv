module TopModule (
    input  clk,
    input  reset,
    input  [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output reg dfr
);

    // Water levels encoding
    localparam BELOW_S0       = 2'd0;
    localparam BETWEEN_S1_S0  = 2'd1;
    localparam BETWEEN_S2_S1  = 2'd2;
    localparam ABOVE_S2       = 2'd3;

    reg [1:0] curr_level;
    reg [1:0] prev_level;

    // Decode sensor pattern to water level
    function [1:0] decode_level(input [2:0] sensors);
        begin
            case (sensors)
                3'b111: decode_level = ABOVE_S2;
                3'b011: decode_level = BETWEEN_S2_S1;
                3'b010: decode_level = BETWEEN_S2_S1;
                3'b001: decode_level = BETWEEN_S1_S0;
                3'b000: decode_level = BELOW_S0;
                default: decode_level = BELOW_S0; // Treat ambiguous as lowest for safety
            endcase
        end
    endfunction

    reg [2:0] prev_s; // to detect changes

    always @(posedge clk) begin
        if (reset) begin
            curr_level <= BELOW_S0;
            prev_level <= BELOW_S0;
            prev_s <= 3'b000;
            dfr <= 1'b1; // supplemental flow valve on at reset
        end else begin
            if (s != prev_s) begin
                prev_level <= curr_level;
                curr_level <= decode_level(s);
                prev_s <= s;
                dfr <= (decode_level(s) > curr_level) ? 1'b1 :
                       (decode_level(s) > prev_level) ? 1'b1 : 1'b0;
            end else begin
                dfr <= 1'b0;
            end
        end
    end

    // Assign nominal flow outputs combinationally
    assign fr2 = (curr_level == BELOW_S0);
    assign fr1 = (curr_level == BELOW_S0 || curr_level == BETWEEN_S1_S0);
    assign fr0 = (curr_level != ABOVE_S2);

endmodule