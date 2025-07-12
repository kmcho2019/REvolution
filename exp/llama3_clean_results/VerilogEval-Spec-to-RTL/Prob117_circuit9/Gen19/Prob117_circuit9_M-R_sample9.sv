module TopModule(
    input clk,
    input a,
    output reg [2:0] q
);

// Initialize the state
initial q = 4;

// Update the state at every positive edge of the clock
always @(posedge clk) begin
    if (a) begin
        q <= 4;
    end else begin
        q <= (q == 6) ? 0 : q + 1;
    end
end

endmodule