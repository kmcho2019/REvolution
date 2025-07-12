module TopModule(
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output Z
);

// Create 8-bit shift register with 8 D-type flip-flops
reg [7:0] Q;

always @(posedge clk) begin
    if (enable) begin
        Q[7:1] <= Q[6:0];
        Q[0] <= S;
    end
end

// Use multiplexers to select output Z based on inputs A, B, and C
wire [2:0] select = {A, B, C};
assign Z = (select == 3'b000)? Q[0] :
           (select == 3'b001)? Q[1] :
           (select == 3'b010)? Q[2] :
           (select == 3'b011)? Q[3] :
           (select == 3'b100)? Q[4] :
           (select == 3'b101)? Q[5] :
           (select == 3'b110)? Q[6] :
           (select == 3'b111)? Q[7] : 1'bx;

endmodule