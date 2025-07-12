module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output out
);

    reg state;

    // Synchronous reset and next state logic combined
    always @(posedge clk) begin
        if (reset)
            state <= 1'b0;            // OFF state
        else
            state <= (state == 1'b0) ? (j ? 1'b1 : 1'b0)
                                     : (k ? 1'b0 : 1'b1);
    end

    // Output equals state (OFF=0, ON=1)
    assign out = state;

endmodule