module signal_generator (
    input             clk,
    input             rst_n,
    output reg [4:0]  wave
);

    reg state; // 0: increment, 1: decrement

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            wave <= 5'd0;
            state <= 1'b0;
        end else begin
            // Update wave based on current state
            if (state == 1'b0)
                wave <= wave + 5'd1;
            else
                wave <= wave - 5'd1;

            // Update state based on new wave value
            // To do this correctly, check wave bounds after increment/decrement
            // So compute next_wave value in a variable
        end
    end

endmodule