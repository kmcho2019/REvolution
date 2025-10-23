module signal_generator(
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg [1:0] state; // Using 2-bit state register for more efficient encoding

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= 0;
        wave <= 0;
    end else begin
        case (state)
            0: begin // Incrementing state
                wave <= wave + 1;
                if (wave == 31) begin
                    state <= 1; // Transition to decrementing state
                end
            end
            1: begin // Decrementing state
                wave <= wave - 1;
                if (wave == 0) begin
                    state <= 0; // Transition back to incrementing state
                end
            end
        endcase
    end
end

endmodule