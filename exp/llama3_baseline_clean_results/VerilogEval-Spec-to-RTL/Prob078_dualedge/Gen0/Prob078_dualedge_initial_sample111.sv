module TopModule(
    input clk,
    input d,
    output reg q
);

reg clk_int; // Internal clock running at twice the speed
reg d_int;   // Data synchronized with the internal clock

// Generate the internal clock running at twice the speed
always @(posedge clk or negedge clk) begin
    clk_int <= ~clk_int;
end

// Synchronize the input data with the internal clock
always @(posedge clk_int) begin
    d_int <= d;
end

// Latch the data on the rising edge of the internal clock
always @(posedge clk_int) begin
    q <= d_int;
end

endmodule