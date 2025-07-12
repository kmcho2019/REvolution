module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        wave <= 5'b0;
    end else begin
        if (&wave[3:0]) begin  // approaching 31 (all lower bits 1)
            wave <= (wave[4]) ? wave - 1'b1 : wave + 1'b1;
        end else if (|wave[4:1]) begin  // above 0
            wave <= (wave[4]) ? wave - 1'b1 : wave + 1'b1;
        end else begin  // at 0
            wave <= wave + 1'b1;
        end
    end
end

endmodule