// Improved version with minor optimization for better readability and synthesis
module TopModule(
    input  [2:0] sel,
    input  [3:0] data0,
    input  [3:0] data1,
    input  [3:0] data2,
    input  [3:0] data3,
    input  [3:0] data4,
    input  [3:0] data5,
    output reg [3:0] out
);

always @(*) begin
    case (sel)
        3'b000: out = data0;
        3'b001: out = data1;
        3'b010: out = data2;
        3'b011: out = data3;
        3'b100: out = data4;
        3'b101: out = data5;
        default: out = 4'b0000; // Explicitly define the default output as 4-bit 0
    endcase
end

// Consider adding synthesis directives or attributes for further optimization
// For example, in some synthesis tools, you can use attributes like '(* area_opt *)' to guide area optimization
// However, these directives are tool-specific and should be used based on the synthesis tool's documentation

endmodule