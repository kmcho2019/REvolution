module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        wave <= 5'b0;
    end else begin
        wave <= (wave == 5'd31) ? wave - 1'b1 : 
                (wave == 5'd0)  ? wave + 1'b1 :
                (wave[4])        ? wave - 1'b1 : wave + 1'b1;
    end
end

endmodule