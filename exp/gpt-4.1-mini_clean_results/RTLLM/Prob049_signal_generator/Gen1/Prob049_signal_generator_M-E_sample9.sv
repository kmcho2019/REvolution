module signal_generator (
    input  wire       clk,
    input  wire       rst_n,
    output reg [4:0]  wave
);

    reg direction; // 1: increment, 0: decrement

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wave      <= 5'd0;
            direction <= 1'b1; // start by incrementing
        end else begin
            if (direction) begin
                if (wave == 5'd31) begin
                    direction <= 1'b0;
                    wave      <= wave - 1'b1;
                end else begin
                    wave <= wave + 1'b1;
                end
            end else begin
                if (wave == 5'd0) begin
                    direction <= 1'b1;
                    wave      <= wave + 1'b1;
                end else begin
                    wave <= wave - 1'b1;
                end
            end
        end
    end

endmodule