module TopModule (
    input clk,
    input reset,
    input j,
    input k,
    output out
);

    reg state;

    always @(posedge clk) begin
        if (reset)
            state <= 0; // OFF
        else if (state == 0) // OFF
            state <= j ? 1 : 0;
        else // ON
            state <= k ? 0 : 1;
    end

    assign out = state;

endmodule