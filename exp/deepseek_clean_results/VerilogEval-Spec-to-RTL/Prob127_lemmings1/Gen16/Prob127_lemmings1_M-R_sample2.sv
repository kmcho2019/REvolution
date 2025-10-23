module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    // State is maintained through combinational feedback
    wire state;
    reg state_reg;

    // State transition logic
    assign state = areset ? 1'b0 : 
                  (bump_left & ~state_reg) ? 1'b1 :
                  (bump_right & state_reg) ? 1'b0 :
                  state_reg;

    // State register with clock
    always @(posedge clk) begin
        state_reg <= state;
    end

    // Output assignments
    assign walk_left = ~state;
    assign walk_right = state;

endmodule