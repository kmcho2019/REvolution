module signal_generator (
    input             clk,
    input             rst_n,
    output reg [4:0]  wave
);

    reg state; // 0: increment, 1: decrement
    reg [4:0] next_wave;

    // Compute next wave value based on state and current wave value
    always @(*) begin
        case (state)
            1'b0: // increment mode
                next_wave = (wave == 5'd31) ? wave : wave + 5'd1;
            1'b1: // decrement mode
                next_wave = (wave == 5'd0) ? wave : wave - 5'd1;
            default:
                next_wave = wave; // safe fallback
        endcase
    end

    // Sequential logic: update wave and state synchronously with async reset
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            wave  <= 5'd0;
            state <= 1'b0;
        end else begin
            wave <= next_wave;

            // Toggle state only when wave hits boundaries
            if ((state == 1'b0 && wave == 5'd31) || (state == 1'b1 && wave == 5'd0))
                state <= ~state;
        end
    end

endmodule