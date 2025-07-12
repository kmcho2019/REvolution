module TopModule(
    input clk,
    input a,
    output reg [2:0] q
);

always @(posedge clk) begin
    if (a) begin
        q <= 4; // Reset q to 4 when a is high
    end else begin
        q <= (q == 6) ? 0 : q + 1; // Wrap around to 0 when q reaches 6, else increment q
    end
end

// Initialize the output
initial q = 4;

endmodule