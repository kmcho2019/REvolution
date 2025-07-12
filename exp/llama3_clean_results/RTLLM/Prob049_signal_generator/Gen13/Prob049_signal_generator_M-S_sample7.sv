module signal_generator(
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg direction;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        wave <= 5'd0;
        direction <= 1'b1;
    end else begin
        if (direction) begin
            wave <= (wave == 5'd31) ? 5'd31 : wave + 1'd1;
            if (wave == 5'd31) direction <= 1'b0;
        end else begin
            wave <= (wave == 5'd0) ? 5'd0 : wave - 1'd1;
            if (wave == 5'd0) direction <= 1'b1;
        end
    end
end

endmodule