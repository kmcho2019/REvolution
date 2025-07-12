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

wire [5:0] enables;

// Decode the select signal
assign enables[0] = (sel == 3'b000);
assign enables[1] = (sel == 3'b001);
assign enables[2] = (sel == 3'b010);
assign enables[3] = (sel == 3'b011);
assign enables[4] = (sel == 3'b100);
assign enables[5] = (sel == 3'b101);

// For each bit position in the output
always @(*) begin
    out[0] = (enables[0] && data0[0]) || (enables[1] && data1[0]) || (enables[2] && data2[0]) || (enables[3] && data3[0]) || (enables[4] && data4[0]) || (enables[5] && data5[0]);
    out[1] = (enables[0] && data0[1]) || (enables[1] && data1[1]) || (enables[2] && data2[1]) || (enables[3] && data3[1]) || (enables[4] && data4[1]) || (enables[5] && data5[1]);
    out[2] = (enables[0] && data0[2]) || (enables[1] && data1[2]) || (enables[2] && data2[2]) || (enables[3] && data3[2]) || (enables[4] && data4[2]) || (enables[5] && data5[2]);
    out[3] = (enables[0] && data0[3]) || (enables[1] && data1[3]) || (enables[2] && data2[3]) || (enables[3] && data3[3]) || (enables[4] && data4[3]) || (enables[5] && data5[3]);
end

endmodule