module TopModule(
    input clk,
    input a,
    output reg [2:0] q
);

always @(posedge clk) begin
    if (a) begin
        q <= 4; // Direct calculation for next state when a is high
    end else begin
        q <= (q < 6) ? (q + 1) : 0; // Conditional increment or wrap-around when a is low
    end
end

// Initialize the output
initial q = 4;

endmodule