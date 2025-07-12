module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

wire [3:0] next_shift = {q[2:0], data};  // Left shift with new data at LSB
wire [3:0] next_count = q - 1'b1;        // Decrement
wire [3:0] next_q;

assign next_q = shift_ena ? next_shift : 
                count_ena ? next_count : 
                q;

always @(posedge clk) begin
    q <= next_q;
end

endmodule