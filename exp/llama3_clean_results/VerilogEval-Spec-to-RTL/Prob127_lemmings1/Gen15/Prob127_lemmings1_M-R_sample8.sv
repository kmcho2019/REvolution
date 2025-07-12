module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output reg walk_left,
    output reg walk_right
);

// Define a 2-bit state variable
reg [1:0] state;

// Use combinational logic for next state
wire next_state;
assign next_state = (state == 2'b01 && bump_left) || (state == 2'b10 && bump_right) ? ~state[0] : state[0];

// Sequential logic for state update
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b01; // Initialize state to LEFT
    end else begin
        state <= {next_state, 1'b0}; // Update state
    end
end

// Use assign statements for output logic
assign walk_left = (state == 2'b01);
assign walk_right = (state == 2'b10);

endmodule