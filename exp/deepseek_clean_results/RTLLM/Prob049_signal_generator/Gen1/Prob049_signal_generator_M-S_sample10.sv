module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        wave <= 5'b0;
    end
    else begin
        if (&wave) begin           // When wave == 31 (all bits 1)
            wave <= wave - 1'b1;   // Start decrementing
        end
        else if (~|wave) begin     // When wave == 0 (all bits 0)
            wave <= wave + 1'b1;   // Start incrementing
        end
        else begin
            wave <= wave + {4'b0, ~wave[4]};  // Add +1 or -1 based on direction
        end
    end
end

endmodule