module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg direction;  // 0 = increment, 1 = decrement

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        wave <= 5'b0;
        direction <= 1'b0;
    end
    else begin
        case (direction)
            1'b0: begin // Incrementing
                wave <= wave + 1;
                if (wave == 5'd30) direction <= 1'b1;
            end
            1'b1: begin // Decrementing
                wave <= wave - 1;
                if (wave == 5'd1) direction <= 1'b0;
            end
        endcase
    end
end

endmodule