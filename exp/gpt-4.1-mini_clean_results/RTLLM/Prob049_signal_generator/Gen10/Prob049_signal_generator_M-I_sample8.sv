module signal_generator (
    input             clk,
    input             rst_n,
    output reg [4:0]  wave
);

    reg direction; // 0: increment, 1: decrement

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            wave      <= 5'd0;
            direction <= 1'b0;
        end else begin
            // At boundary points, toggle direction
            if ((direction == 1'b0) && (wave == 5'd31))
                direction <= 1'b1;
            else if ((direction == 1'b1) && (wave == 5'd0))
                direction <= 1'b0;

            // Update wave only if it will change (to reduce toggling)
            if ((direction == 1'b0) && (wave != 5'd31))
                wave <= wave + 5'd1;
            else if ((direction == 1'b1) && (wave != 5'd0))
                wave <= wave - 5'd1;
            else
                wave <= wave; // Hold value at boundaries
        end
    end

endmodule