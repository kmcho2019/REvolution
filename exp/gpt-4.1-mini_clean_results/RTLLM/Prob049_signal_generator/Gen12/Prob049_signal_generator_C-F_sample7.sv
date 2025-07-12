module signal_generator (
    input             clk,
    input             rst_n,
    output reg [4:0]  wave
);

    reg state;           // 0: increment, 1: decrement
    wire [4:0] next_wave;

    // Combinational logic to determine next wave value based on current state and wave
    assign next_wave = (state == 1'b0) ? (wave + 5'd1) : (wave - 5'd1);

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            wave  <= 5'd0;
            state <= 1'b0;
        end else begin
            wave <= next_wave;

            // Flip state only when wave hits bounds after update
            if ((state == 1'b0 && wave == 5'd31) || (state == 1'b1 && wave == 5'd0)) begin
                state <= ~state;
            end
        end
    end

endmodule