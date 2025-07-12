module signal_generator (
    input           clk,
    input           rst_n,
    output reg [4:0] wave
);

    reg direction;  // 0: increment, 1: decrement

    // Combinational next wave value based on current wave and direction
    wire [4:0] next_wave = (direction == 1'b0) ? (wave + 5'd1) : (wave - 5'd1);

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            wave <= 5'd0;
            direction <= 1'b0;  // start incrementing
        end else begin
            wave <= next_wave;

            // Toggle direction at boundaries
            if ((direction == 1'b0 && wave == 5'd31) ||
                (direction == 1'b1 && wave == 5'd0)) begin
                direction <= ~direction;
            end
        end
    end

endmodule