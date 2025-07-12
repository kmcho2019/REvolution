module TopModule (
    input           clk,
    input           shift_ena,
    input           count_ena,
    input           data,
    output reg [3:0] q
);

wire [3:0] shifted;    // result of shifting left (LSB shift in)
wire [3:0] decremented; // result of decrementing by one

assign shifted = {q[2:0], data}; // shift left by one, data into LSB
assign decremented = q + 4'b1111; // q - 1 via two's complement addition

always @(posedge clk) begin
    if (shift_ena) 
        q <= shifted;
    else if (count_ena) 
        q <= decremented;
    else
        q <= q;
end

endmodule