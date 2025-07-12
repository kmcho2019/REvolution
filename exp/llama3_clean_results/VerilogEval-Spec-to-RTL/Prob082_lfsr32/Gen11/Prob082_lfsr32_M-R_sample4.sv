module TopModule(
    input  clk,
    input  reset,
    output reg [31:0] q
);

reg [31:0] next_q;

always @(posedge clk) begin
    if (reset) begin
        q <= 32'h1;
    end else begin
        q <= next_q;
    end
end

always @(*) begin
    // Calculate the feedback term by XORing the bits at the tap positions
    reg fb;
    assign fb = q[31] ^ q[21] ^ q[1] ^ q[0];
    
    // Generate the next state by shifting the current state and applying the feedback term
    next_q = {fb, q[31:1]};
end

endmodule