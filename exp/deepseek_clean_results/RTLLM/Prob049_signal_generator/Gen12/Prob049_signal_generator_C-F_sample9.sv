module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg state;  // 0: increment, 1: decrement

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        wave <= 5'b0;
        state <= 1'b0;
    end else begin
        case (state)
            1'b0: begin  // Increment phase
                if (&wave) begin  // Efficient max value check
                    state <= 1'b1;
                end else begin
                    wave <= wave + 1'b1;
                end
            end
            1'b1: begin  // Decrement phase
                if (wave == 5'b0) begin  // Direct 0 comparison
                    state <= 1'b0;
                end else begin
                    wave <= wave - 1'b1;
                end
            end
        endcase
    end
end

endmodule