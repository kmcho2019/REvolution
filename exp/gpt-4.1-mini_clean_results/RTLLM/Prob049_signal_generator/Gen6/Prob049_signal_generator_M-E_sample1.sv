module signal_generator (
    input        clk,
    input        rst_n,
    output reg [4:0] wave
);

    reg direction; // 1: increment, 0: decrement

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            wave <= 5'd0;
            direction <= 1'b1; // start incrementing
        end else begin
            if (direction) begin
                // increment direction
                if (wave == 5'd31) begin
                    direction <= 1'b0; // switch to decrement
                    wave <= wave - 1;
                end else begin
                    wave <= wave + 1;
                end
            end else begin
                // decrement direction
                if (wave == 5'd0) begin
                    direction <= 1'b1; // switch to increment
                    wave <= wave + 1;
                end else begin
                    wave <= wave - 1;
                end
            end
        end
    end

endmodule