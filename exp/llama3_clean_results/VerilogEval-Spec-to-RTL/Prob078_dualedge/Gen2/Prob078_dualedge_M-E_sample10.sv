module TopModule(
    input clk,
    input d,
    output reg q
);

reg clk_prev;  // Previous state of the clock
reg j, k;      // Inputs to the JK flip-flop

// Detect rising and falling edges of the clock
always @(posedge clk) begin
    clk_prev <= 1'b1;
end

always @(negedge clk) begin
    clk_prev <= 1'b0;
end

// Determine J and K inputs based on the edge detection and input data
always @(clk or clk_prev or d) begin
    if (clk == 1'b1 && clk_prev == 1'b0) begin  // Rising edge
        j <= d;
        k <= ~d;
    end else if (clk == 1'b0 && clk_prev == 1'b1) begin  // Falling edge
        j <= ~d;
        k <= d;
    end else begin
        j <= 1'b0;
        k <= 1'b0;
    end
end

// JK flip-flop implementation
always @(posedge clk) begin
    if (j == 1'b1 && k == 1'b1) begin
        q <= ~q;
    end else if (j == 1'b1) begin
        q <= 1'b1;
    end else if (k == 1'b1) begin
        q <= 1'b0;
    end
end

endmodule