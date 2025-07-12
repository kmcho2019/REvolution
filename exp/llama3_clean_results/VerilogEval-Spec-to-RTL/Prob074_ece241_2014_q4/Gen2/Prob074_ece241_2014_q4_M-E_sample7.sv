module TopModule(
    input clk,
    input x,
    output reg z
);

reg [2:0] state;

initial begin
    state = 0;
end

always @(posedge clk) begin
    reg xor_next, and_next, or_next;
    reg [2:0] next_state;
    
    xor_next = x ^ state[0];
    and_next = x & ~state[1];
    or_next = x | ~state[2];
    
    next_state = {or_next, and_next, xor_next};
    state <= next_state;
end

always @(*) begin
    z = ~( (x ^ state[0]) | (x & ~state[1]) | (x | ~state[2]) );
end

endmodule