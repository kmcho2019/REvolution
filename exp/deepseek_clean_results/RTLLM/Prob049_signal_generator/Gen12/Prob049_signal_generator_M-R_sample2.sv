module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

// Direction control (combinational logic)
wire at_max = (wave == 5'b11111);
wire at_min = (wave == 5'b00000);
wire direction = (at_max) ? 1'b1 : 
                 (at_min) ? 1'b0 : 
                 direction_reg;

reg direction_reg;

// Wave update logic (sequential)
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        wave <= 5'b0;
        direction_reg <= 1'b0;
    end else begin
        direction_reg <= direction;
        wave <= direction ? wave - 1'b1 : wave + 1'b1;
    end
end

endmodule