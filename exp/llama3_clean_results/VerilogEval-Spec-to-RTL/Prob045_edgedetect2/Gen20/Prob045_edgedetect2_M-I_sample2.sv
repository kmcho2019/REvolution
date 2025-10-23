module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

reg [7:0] curr_state = 0;  // Explicitly initialize current state to zero
reg [7:0] prev_state = 0;  // Explicitly initialize previous state to zero

always @(posedge clk) begin
    prev_state <= curr_state;  // Update previous state
    curr_state <= in;  // Update current state
end

// Perform edge detection using XOR and assign the result to anyedge
// The XOR operation detects any edge (rising or falling) between curr_state and prev_state
always @(posedge clk) begin
    anyedge <= curr_state ^ prev_state;
end

endmodule