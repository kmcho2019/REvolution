module ring_counter (
    input wire clk,
    input wire reset,
    output wire [7:0] out
);

reg [7:0] state;
wire [7:0] next_state;

// Combinational rotation logic
assign next_state = {state[6:0], state[7]};

// Output assignment
assign out = state;

// Sequential state update
always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 8'b00000001;  // Initialize with LSB set
    end else begin
        state <= next_state;   // Update with rotated value
    end
end

endmodule