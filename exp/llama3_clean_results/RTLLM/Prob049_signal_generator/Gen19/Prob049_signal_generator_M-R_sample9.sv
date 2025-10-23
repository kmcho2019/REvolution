module signal_generator(
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg [4:0] wave_reg;
reg state;

wire increment;
wire decrement;
wire state_next;

assign increment = (state == 0) && (wave_reg != 31);
assign decrement = (state == 1) && (wave_reg != 0);
assign state_next = (wave_reg == 31) ? 1 : ((wave_reg == 0) ? 0 : state);

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= 0;
    end else begin
        state <= state_next;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        wave_reg <= 0;
    end else if (increment) begin
        wave_reg <= wave_reg + 1;
    end else if (decrement) begin
        wave_reg <= wave_reg - 1;
    end
end

assign wave = wave_reg;

endmodule