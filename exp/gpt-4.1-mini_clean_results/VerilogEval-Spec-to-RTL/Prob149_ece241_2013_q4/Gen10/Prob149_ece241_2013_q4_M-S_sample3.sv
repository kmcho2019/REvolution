module TopModule (
    input        clk,
    input        reset,
    input  [2:0] s,
    output       fr2,
    output       fr1,
    output       fr0,
    output reg   dfr
);

    // Define water level states by encoding sensor inputs explicitly
    // We'll map sensor patterns directly to integer levels:
    // 0 = below s0 (000)
    // 1 = between s1 and s0 (001)
    // 2 = between s2 and s1 (011)
    // 3 = above s2 (111)
    // All other sensor patterns treated as below s0 (0)

    reg [1:0] curr_level;
    reg [1:0] prev_level;

    // Decode sensor inputs to water level integer
    function [1:0] decode_level(input [2:0] sensors);
        begin
            case (sensors)
                3'b000: decode_level = 2'd0; // below s0
                3'b001: decode_level = 2'd1; // between s1 and s0
                3'b011: decode_level = 2'd2; // between s2 and s1
                3'b111: decode_level = 2'd3; // above s2
                default: decode_level = 2'd0; // treat others as below s0
            endcase
        end
    endfunction

    // Update levels and dfr on clock edge
    always @(posedge clk) begin
        if (reset) begin
            curr_level <= 2'd0; // below s0 at reset
            prev_level <= 2'd0;
            dfr        <= 1'b1; // all outputs asserted on reset
        end else begin
            prev_level <= curr_level;
            curr_level <= decode_level(s);
            dfr        <= (decode_level(s) > curr_level) ? 1'b1 : 1'b0;
        end
    end

    // Nominal flow rate outputs combinational based on curr_level
    assign fr2 = (curr_level == 2'd0);                      // below s0
    assign fr1 = (curr_level == 2'd0) || (curr_level == 2'd1); // below s0 or between s1 and s0
    assign fr0 = (curr_level != 2'd3);                      // all but above s2

endmodule