module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

wire at_max = &wave;        // All bits are 1 (wave == 31)
wire at_min = ~|wave;       // All bits are 0 (wave == 0)
wire counting_up = ~wave[4]; // MSB indicates direction (0=up, 1=down)

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Active-low reset
        wave <= 5'b0;
    end
    else begin
        case ({at_max, at_min})
            2'b10: wave <= wave - 1'b1; // At max, start counting down
            2'b01: wave <= wave + 1'b1; // At min, start counting up
            default: begin
                if (counting_up)
                    wave <= wave + 1'b1;
                else
                    wave <= wave - 1'b1;
            end
        endcase
    end
end

endmodule