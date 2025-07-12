module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Active-low reset
        wave <= 5'b0;
    end else begin
        // Automatic direction change through overflow/underflow
        wave <= wave + {4'b0, ~wave[4]} - {4'b0, wave[4]};
    end
end

endmodule