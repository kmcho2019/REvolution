module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

reg [1:0] state;

// Internal asynchronous reset signal for simulation initialization
reg reset_n;

initial begin
    reset_n = 0;     // start in reset (outputs unknown initially)
    #1 reset_n = 1;  // release reset shortly after simulation start
end

always @(posedge clock or negedge reset_n) begin
    if (!reset_n) begin
        state <= 2'b00;
    end else begin
        // Increment the 2-bit state by 'a'
        state <= state + a;
    end
end

always @(*) begin
    {p,q} = state;
end

endmodule