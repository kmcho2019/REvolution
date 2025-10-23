module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg state;  // 0 = incrementing, 1 = decrementing

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        wave <= 5'b0;
        state <= 1'b0;
    end else begin
        case (state)
            1'b0: begin  // Increment state
                wave <= wave + 1;
                if (&wave) state <= 1'b1;  // Detect max value using bitwise AND
            end
            1'b1: begin  // Decrement state
                wave <= wave - 1;
                if (~|wave) state <= 1'b0;  // Detect min value using bitwise OR
            end
        endcase
    end
end

endmodule