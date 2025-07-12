module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

    reg state; // 0: increment, 1: decrement

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            state <= 1'b0;
            wave <= 5'd0;
        end else begin
            // Update wave based on state as direction: 0=incr, 1=decr
            wave <= state ? wave - 5'd1 : wave + 5'd1;
            
            // Update state at bounds
            if (state == 1'b0 && wave == 5'd31)
                state <= 1'b1;
            else if (state == 1'b1 && wave == 5'd0)
                state <= 1'b0;
        end
    end

endmodule