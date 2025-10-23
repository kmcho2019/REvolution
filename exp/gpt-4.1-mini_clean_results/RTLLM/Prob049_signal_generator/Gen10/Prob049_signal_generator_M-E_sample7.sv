module signal_generator (
    input         clk,
    input         rst_n,
    output reg [4:0] wave
);

    reg direction; // 1: up, 0: down

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wave <= 5'd0;
            direction <= 1'b1; // start incrementing
        end else begin
            if (direction) begin // counting up
                if (wave == 5'd31)
                    direction <= 1'b0; // switch to down
                else
                    wave <= wave + 1'b1;
            end else begin // counting down
                if (wave == 5'd0)
                    direction <= 1'b1; // switch to up
                else
                    wave <= wave - 1'b1;
            end
        end
    end

endmodule