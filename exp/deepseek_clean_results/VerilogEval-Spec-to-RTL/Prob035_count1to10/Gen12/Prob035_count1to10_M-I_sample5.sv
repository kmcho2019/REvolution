module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

reg wrap;
wire increment = ~wrap & ~reset;

// Combinational logic for wrap detection
always @(*) begin
    wrap = (q == 4'b1010);  // Detect count = 10
end

// Sequential logic with clock gating
always @(posedge clk) begin
    if (reset) begin
        q <= 4'b0001;       // Direct synchronous reset
    end
    else if (wrap) begin
        q <= 4'b0001;       // Wrap with minimal bit changes
    end
    else if (increment) begin
        q <= q + 1;         // Gated increment
    end
end

endmodule