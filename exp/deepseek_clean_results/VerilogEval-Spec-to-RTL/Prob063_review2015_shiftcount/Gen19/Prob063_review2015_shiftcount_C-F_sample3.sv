module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

wire [3:0] next_shift = {q[2:0], data};
wire [3:0] next_count = q - 1'b1;  // Simple decrement

always @(posedge clk) begin
    q <= shift_ena ? next_shift : 
         count_ena ? next_count : q;
end

endmodule