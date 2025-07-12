module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output walk_left,
    output walk_right,
    output aaah
);

// Parameter for the number of states
parameter NUM_STATES = 4;

// One-hot encoded state register
reg [NUM_STATES-1:0] state;
reg [NUM_STATES-1:0] next_state;

// Controller module
always @(*) begin
    next_state = state;

    case(state)
        4'b0001: // walking left
            begin
                if (~ground) begin
                    next_state = 4'b1000; // falling left
                end else if (bump_left) begin
                    next_state = 4'b0010; // walking right
                end else if (bump_right) begin
                    // do nothing, keep walking left
                end
            end
        4'b0010: // walking right
            begin
                if (~ground) begin
                    next_state = 4'b0100; // falling right
                end else if (bump_right) begin
                    next_state = 4'b0001; // walking left
                end else if (bump_left) begin
                    // do nothing, keep walking right
                end
            end
        4'b1000: // falling left
            begin
                if (ground) begin
                    next_state = 4'b0001; // walking left
                end
            end
        4'b0100: // falling right
            begin
                if (ground) begin
                    next_state = 4'b0010; // walking right
                end
            end
    endcase
end

// Sequential logic to update the state
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 4'b0001; // reset to walking left
    end else begin
        state <= next_state;
    end
end

// Data path module (output logic)
assign walk_left = state[0];
assign walk_right = state[1];
assign aaah = state[2] || state[3];

endmodule