module signal_generator (
    input        clk,
    input        rst_n,
    output reg [4:0] wave
);

    reg direction; // 0: increment (up), 1: decrement (down)

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            wave <= 5'd0;
            direction <= 1'b0;
        end else begin
            // Update wave and direction in one step to reduce toggling
            case (direction)
                1'b0: begin
                    // Increment wave; switch direction if top reached
                    if (wave == 5'd31) begin
                        wave <= wave - 1;
                        direction <= 1'b1;
                    end else begin
                        wave <= wave + 1;
                    end
                end
                1'b1: begin
                    // Decrement wave; switch direction if bottom reached
                    if (wave == 5'd0) begin
                        wave <= wave + 1;
                        direction <= 1'b0;
                    end else begin
                        wave <= wave - 1;
                    end
                end
            endcase
        end
    end

endmodule