module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

// Define the states using explicit binary encoding
reg [1:0] state, next_state;

// Initialize the state to A (00)
initial state = 2'b00;

// Directly assign output based on current state
assign out = (state == 2'b11) ? 1'b1 : 1'b0;

// Determine the next state
always @(*) begin
    case ({state, in})
        {2'b00, 1'b0}: next_state = 2'b00; // A, in=0
        {2'b00, 1'b1}: next_state = 2'b01; // A, in=1
        {2'b01, 1'b0}: next_state = 2'b10; // B, in=0
        {2'b01, 1'b1}: next_state = 2'b01; // B, in=1
        {2'b10, 1'b0}: next_state = 2'b00; // C, in=0
        {2'b10, 1'b1}: next_state = 2'b11; // C, in=1
        {2'b11, 1'b0}: next_state = 2'b10; // D, in=0
        {2'b11, 1'b1}: next_state = 2'b01; // D, in=1
        default: next_state = 2'b00; // Default to A
    endcase
end

// Update the state on the positive edge of the clock
always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00; // Reset to state A
    end else begin
        state <= next_state;
    end
end

endmodule