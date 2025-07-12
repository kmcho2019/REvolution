module TopModule (
    input  wire clk,    // System clock (positive edge-triggered)
    input  wire ar,     // Asynchronous reset (active high)
    input  wire d,      // Data input
    output wire q       // Registered output
);

// Internal signals
reg stage1;    // First synchronization stage
reg stage2;    // Second output stage
wire reset;    // Combined reset signal

// Power-on reset initialization
initial begin
    stage1 = 1'b0;
    stage2 = 1'b0;
end

// Combined reset (async or power-on)
assign reset = ar;

// Two-stage flip-flop with metastability protection
always @(posedge clk or posedge reset) begin
    if (reset) begin
        stage1 <= 1'b0;    // Async reset first stage
    end else begin
        stage1 <= d;       // First synchronization stage
    end
end

// Output stage with intentional 1-cycle delay
always @(posedge clk or posedge reset) begin
    if (reset) begin
        stage2 <= 1'b0;    // Async reset second stage
    end else begin
        stage2 <= stage1;  // Delayed output stage
    end
end

// Final output assignment
assign q = stage2;

endmodule