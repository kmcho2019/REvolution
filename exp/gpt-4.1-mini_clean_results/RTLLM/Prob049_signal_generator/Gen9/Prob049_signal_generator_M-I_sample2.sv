module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

    reg direction; // 0: up, 1: down

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            wave <= 5'd0;
            direction <= 1'b0;
        end else begin
            // Determine next wave value based on direction
            wire [4:0] next_wave = direction ? wave - 5'd1 : wave + 5'd1;

            // Update wave
            wave <= next_wave;

            // Toggle direction if hitting boundaries
            if ((direction == 1'b0 && wave == 5'd31) || (direction == 1'b1 && wave == 5'd0))
                direction <= ~direction;
        end
    end

endmodule