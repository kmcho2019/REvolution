module TopModule (
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

    // States: count of consecutive 1s (0-6)
    reg [2:0] state;

    // State transitions
    always @(posedge clk) begin
        if (reset) begin
            state <= 0;
        end else begin
            if (in) begin
                if (state < 6) state <= state + 1;
            end else begin
                state <= 0;
            end
        end
    end

    // Output logic
    assign disc = (state == 5) && !in;  // 5 1s followed by 0
    assign flag = (state == 6) && !in;  // 6 1s followed by 0
    assign err  = (state == 6) && in;   // 7th 1 seen

endmodule