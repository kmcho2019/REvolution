module signal_generator (
    input  wire       clk,
    input  wire       rst_n,
    output reg [4:0]  wave
);

    reg dir; // 0 = increment, 1 = decrement

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            wave <= 5'd0;
            dir  <= 1'b0;  // start incrementing
        end else begin
            if (dir == 1'b0) begin
                // incrementing
                if (wave == 5'd31) begin
                    dir  <= 1'b1;       // change direction to decrement
                    wave <= wave - 5'd1;
                end else begin
                    wave <= wave + 5'd1;
                end
            end else begin
                // decrementing
                if (wave == 5'd0) begin
                    dir  <= 1'b0;       // change direction to increment
                    wave <= wave + 5'd1;
                end else begin
                    wave <= wave - 5'd1;
                end
            end
        end
    end

endmodule