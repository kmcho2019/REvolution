module signal_generator (
    input             clk,
    input             rst_n,
    output reg [4:0]  wave
);

    reg state; // 0: increment, 1: decrement

    // State update block: update state based on current wave value
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= 1'b0;
        else begin
            case(state)
                1'b0: if (wave == 5'd31) state <= 1'b1;
                1'b1: if (wave == 5'd0)  state <= 1'b0;
                default: state <= 1'b0;
            endcase
        end
    end

    // Wave update block: update wave depending on current state
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            wave <= 5'd0;
        else begin
            case(state)
                1'b0: if (wave < 5'd31) wave <= wave + 5'd1;
                1'b1: if (wave > 5'd0)  wave <= wave - 5'd1;
            endcase
        end
    end

endmodule