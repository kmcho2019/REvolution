module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output wire z
);

localparam A = 2'b01;
localparam B = 2'b10;

reg [1:0] state, next_state;

always @(*) begin
    // From A: next is A if x=0, B if x=1
    // From B: next is always B
    next_state = (state == A) ? (x ? B : A) : B;
end

assign z = (state[0] & x) | (state[1] & ~x);

always @(posedge clk or posedge areset) begin
    if (areset)
        state <= A;
    else
        state <= next_state;
end

endmodule