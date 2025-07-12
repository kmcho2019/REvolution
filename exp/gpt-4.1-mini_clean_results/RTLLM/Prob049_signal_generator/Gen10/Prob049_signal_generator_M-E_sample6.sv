module signal_generator (
    input           clk,
    input           rst_n,
    output reg [4:0] wave
);

    reg direction; // 0: increment, 1: decrement

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wave <= 5'd0;
            direction <= 1'b0; // start by incrementing
        end else begin
            if (direction == 1'b0) begin
                // increment mode
                if (wave == 5'd31)
                    direction <= 1'b1; // switch to decrement
                else
                    wave <= wave + 5'd1;
            end else begin
                // decrement mode
                if (wave == 5'd0)
                    direction <= 1'b0; // switch to increment
                else
                    wave <= wave - 5'd1;
            end
        end
    end

endmodule