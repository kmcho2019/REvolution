module TopModule(
    input clk,
    input a,
    output reg [2:0] q
);

// Initialize the output
initial q = 4;

// Update the current state at every positive edge of the clock
always @(posedge clk) begin
    if (a) begin
        q <= 4;
    end else if (q < 6) begin
        q <= q + 1;
    end else begin
        q <= 0;
    end
end

endmodule