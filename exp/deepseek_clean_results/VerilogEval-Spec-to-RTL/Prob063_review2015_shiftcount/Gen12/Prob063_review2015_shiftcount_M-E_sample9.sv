module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

wire rotate = shift_ena | count_ena;
wire [3:0] rotate_in = shift_ena ? {q[2:0], data} : 
                      count_ena ? {q[0], q[3:1] ^ {3{q[0]}}} : q;

always @(posedge clk) begin
    if (rotate)
        q <= rotate_in;
    // else hold (implicit)
end

endmodule