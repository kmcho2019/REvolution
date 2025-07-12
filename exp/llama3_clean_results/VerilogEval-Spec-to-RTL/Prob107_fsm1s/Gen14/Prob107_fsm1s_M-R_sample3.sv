module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

// Define states using binary encoding
localparam STATE_B = 1'b0;
localparam STATE_A = 1'b1;

// State register
reg state;

// Next state logic
wire next_state;
assign next_state = (state == STATE_B)? (in? STATE_B : STATE_A) : (in? STATE_A : STATE_B);

// Output assignment based on current state
assign out = ~state; // Out is 1 in state B (0) and 0 in state A (1)

// State transition logic
always @(posedge clk) begin
    if(reset) begin
        state <= STATE_B; // Synchronous reset to state B
    end else begin
        state <= next_state;
    end
end

endmodule