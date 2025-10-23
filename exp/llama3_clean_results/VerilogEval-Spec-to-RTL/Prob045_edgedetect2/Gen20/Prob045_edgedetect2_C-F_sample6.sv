module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

reg [7:0] curr_state = 8'b0;  // Initialize current state to zero
reg [7:0] prev_state = 8'b0;  // Initialize previous state to zero

always @(posedge clk) begin
    prev_state <= curr_state;  // Update previous state
    curr_state <= in;  // Update current state
end

assign anyedge = curr_state ^ prev_state;  // Detect edges using XOR

endmodule