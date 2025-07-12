module TopModule(
    input  clk,
    input  reset,
    output reg [3:0] q
);

// Using a parameter for the counter width for better flexibility and readability
parameter WIDTH = 4;

// The main sequential logic
always @(posedge clk) begin
    if (reset) begin
        // Synchronous reset to 0
        q <= {WIDTH{1'b0}};
    end else begin
        // Increment the counter, wrapping around to 0 after 15
        q <= (q == (2**WIDTH - 1))? {WIDTH{1'b0}} : q + 1;
    end
end

endmodule