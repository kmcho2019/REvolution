module signal_generator (
    input clk,
    input rst_n,
    output [4:0] wave
);

reg [4:0] wave_reg;
reg direction;  // 0 = increment, 1 = decrement
wire at_max = &wave_reg;      // All bits high (31)
wire at_min = ~|wave_reg;     // All bits low (0)
wire clk_en = ~(at_max & ~direction) & ~(at_min & direction);

// Gray code conversion
assign wave = {wave_reg[4],
              wave_reg[4] ^ wave_reg[3],
              wave_reg[3] ^ wave_reg[2],
              wave_reg[2] ^ wave_reg[1],
              wave_reg[1] ^ wave_reg[0]};

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        wave_reg <= 5'b0;
        direction <= 1'b0;
    end else if (clk_en) begin
        wave_reg <= direction ? wave_reg - 1 : wave_reg + 1;
        if ((at_max & ~direction) || (at_min & direction)) begin
            direction <= ~direction;
        end
    end
end

endmodule