module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

wire [3:0] next_q;

// Improved decrement logic with carry lookahead
assign next_q = count_ena ? {q[3] ^ &q[2:0],
                            q[2] ^ &q[1:0],
                            q[1] ^ q[0],
                            ~q[0]} : 
                shift_ena ? {q[2:0], data} : q;

always @(posedge clk) begin
    q <= next_q;
end

endmodule