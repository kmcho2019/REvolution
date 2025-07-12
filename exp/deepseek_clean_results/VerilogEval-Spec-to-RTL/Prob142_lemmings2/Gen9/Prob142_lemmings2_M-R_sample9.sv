module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output walk_left,
    output walk_right,
    output aaah
);

    // State encoding: [1]=falling, [0]=direction (0=left, 1=right)
    reg [1:0] state;

    // Combinational logic for next state
    wire falling_next = (!ground) ? 1'b1 :           // Start falling
                        (ground) ? 1'b0 :           // Stop falling
                         state[1];                   // Default maintain

    wire direction_next = (areset) ? 1'b0 :          // Reset to left
                          (!state[1] && ground) ?     // Only update direction when walking on ground
                              ((state[0] && bump_right) || (!state[0] && bump_left) ? 
                                  !state[0] : state[0]) :
                          state[0];                  // Maintain direction otherwise

    // State register with async reset
    always @(posedge clk, posedge areset) begin
        if (areset)
            state <= 2'b00;  // Walking left
        else
            state <= {falling_next, direction_next};
    end

    // Output assignments
    assign walk_left = !state[1] && !state[0];
    assign walk_right = !state[1] && state[0];
    assign aaah = state[1];

endmodule