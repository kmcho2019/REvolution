module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

wire [5:0] next_inc = {1'b0, wave} + 6'b1;
wire [5:0] next_dec = {1'b0, wave} - 6'b1;
reg direction;  // 0=inc, 1=dec

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        wave <= 5'b0;
        direction <= 1'b0;
    end else begin
        if (direction == 0) begin
            wave <= next_inc[4:0];
            direction <= next_inc[5];
        end else begin
            wave <= next_dec[4:0];
            direction <= ~next_dec[5];
        end
    end
end

endmodule