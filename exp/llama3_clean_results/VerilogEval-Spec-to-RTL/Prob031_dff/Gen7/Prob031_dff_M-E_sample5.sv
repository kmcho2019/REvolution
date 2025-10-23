// Novel architectural idea: Implementing a D flip-flop using a clocked latch
module TopModule(
    input clk, // Clock signal
    input d,   // Data input
    output reg q // Output of the D flip-flop
);

// Internal signals for the latch implementation
reg en; // Enable signal for the latch
reg data; // Data stored in the latch

// Implementing the enable signal (active high when clk is high)
always @(clk) begin
    if (clk == 1'b1) begin
        en <= 1'b1;
    end else begin
        en <= 1'b0;
    end
end

// Implementing the latch
always @(en or d) begin
    if (en == 1'b1) begin
        data <= d;
    end
end

// Output 'q' is the data stored in the latch
always @(data) begin
    q <= data;
end

endmodule