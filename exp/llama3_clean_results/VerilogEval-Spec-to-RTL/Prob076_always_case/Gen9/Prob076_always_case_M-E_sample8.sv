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

reg [3:0] masked_data0, masked_data1, masked_data2, masked_data3, masked_data4, masked_data5;

always @(*) begin
    // Generate masks based on sel
    case (sel)
        3'b000: begin masked_data0 = data0; masked_data1 = 0; masked_data2 = 0; masked_data3 = 0; masked_data4 = 0; masked_data5 = 0; end
        3'b001: begin masked_data0 = 0; masked_data1 = data1; masked_data2 = 0; masked_data3 = 0; masked_data4 = 0; masked_data5 = 0; end
        3'b010: begin masked_data0 = 0; masked_data1 = 0; masked_data2 = data2; masked_data3 = 0; masked_data4 = 0; masked_data5 = 0; end
        3'b011: begin masked_data0 = 0; masked_data1 = 0; masked_data2 = 0; masked_data3 = data3; masked_data4 = 0; masked_data5 = 0; end
        3'b100: begin masked_data0 = 0; masked_data1 = 0; masked_data2 = 0; masked_data3 = 0; masked_data4 = data4; masked_data5 = 0; end
        3'b101: begin masked_data0 = 0; masked_data1 = 0; masked_data2 = 0; masked_data3 = 0; masked_data4 = 0; masked_data5 = data5; end
        default: begin masked_data0 = 0; masked_data1 = 0; masked_data2 = 0; masked_data3 = 0; masked_data4 = 0; masked_data5 = 0; end
    endcase
    
    // Perform bitwise OR to get the final output
    out = masked_data0 | masked_data1 | masked_data2 | masked_data3 | masked_data4 | masked_data5;
end

endmodule