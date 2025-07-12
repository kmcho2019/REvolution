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
        // Increment phase
        if (~state) begin
            wave <= (&wave) ? wave : wave + 1'b1;
            state <= (&wave) ? 1'b1 : state;
        end 
        // Decrement phase
        else begin
            wave <= (~|wave) ? wave : wave - 1'b1;
            state <= (~|wave) ? 1'b0 : state;
        end
    end
end

endmodule