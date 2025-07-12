module TopModule(
    input clk,
    input [7:0] d,
    output reg [7:0] q
);

// Initialize an internal signal to a default value (e.g., 0)
reg [7:0] internal_q = 8'b0;

always @(posedge clk) begin
    // Assign the value of 'd' to the internal signal
    internal_q <= d;
end

// Continuously assign the internal signal's value to 'q'
assign q = internal_q;

endmodule