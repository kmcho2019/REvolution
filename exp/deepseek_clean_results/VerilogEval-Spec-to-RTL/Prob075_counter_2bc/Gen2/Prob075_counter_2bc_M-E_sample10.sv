module TopModule (
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output reg [1:0] state
);

// State encoding: 00 (strong NT), 01 (weak NT), 10 (weak T), 11 (strong T)
wire increment = train_valid & train_taken;
wire decrement = train_valid & ~train_taken;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b01;  // reset to weakly not-taken
    end
    else begin
        if (increment) begin
            // Rotate left with saturation
            state <= (state == 2'b11) ? 2'b11 : {state[0], ~state[1]};
        end
        else if (decrement) begin
            // Rotate right with saturation
            state <= (state == 2'b00) ? 2'b00 : {~state[0], state[1]};
        end
        // else maintain state
    end
end

endmodule