module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        wave <= 5'b0;
    end else begin
        case (wave)
            5'b00000: wave <= wave + 1'b1;  // At min, start incrementing
            5'b11111: wave <= wave - 1'b1;  // At max, start decrementing
            default: begin
                if (wave[4])                // If MSB set (16-31), decrement
                    wave <= wave - 1'b1;
                else                        // Else (0-15), increment
                    wave <= wave + 1'b1;
            end
        endcase
    end
end

endmodule