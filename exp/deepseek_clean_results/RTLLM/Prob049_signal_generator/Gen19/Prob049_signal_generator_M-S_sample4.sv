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
            5'b00000: wave <= wave + 1'b1;  // At min, always increment
            5'b11111: wave <= wave - 1'b1;  // At max, always decrement
            default:  wave <= wave + (wave[4] ? -1'b1 : 1'b1);  // MSB indicates direction
        endcase
    end
end

endmodule