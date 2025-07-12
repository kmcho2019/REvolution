module TopModule(
    input clk,
    input d,
    output reg q
);

// Create a delayed clock signal
reg delayed_clk;
always @(posedge clk or negedge clk) begin
    delayed_clk <= #1 ~clk; // Assuming a 1ns delay
end

// Use the delayed clock to sample the input data
always @(posedge delayed_clk or negedge delayed_clk) begin
    q <= d;
end

endmodule