module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

wire at_max = &wave;        // All bits 1 (31)
wire at_min = ~|wave;       // All bits 0 (0)
wire direction = wave[4];   // MSB indicates direction (0=up, 1=down)

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        wave <= 5'b0;
    end
    else begin
        case ({at_max, at_min})
            2'b10: wave <= wave - 1;    // At max, start decreasing
            2'b01: wave <= wave + 1;    // At min, start increasing
            default: wave <= direction ? wave - 1 : wave + 1;
        endcase
    end
end

endmodule