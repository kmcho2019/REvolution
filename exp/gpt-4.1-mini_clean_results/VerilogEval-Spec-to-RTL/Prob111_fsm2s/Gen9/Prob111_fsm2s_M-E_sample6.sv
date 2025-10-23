module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output reg out
);

    // State encoding
    localparam OFF = 1'b0,
               ON  = 1'b1;

    reg state;

    always @(posedge clk) begin
        if (reset) begin
            state <= OFF;
            out <= 1'b0;
        end else begin
            // Determine next state combinationally inside sequential block
            if (state == OFF) begin
                state <= (j) ? ON : OFF;
            end else begin // state == ON
                state <= (k) ? OFF : ON;
            end
            // Output follows current state (Moore output)
            out <= state;
        end
    end

endmodule