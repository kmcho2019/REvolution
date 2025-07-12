module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output out
);

    reg state; // 0 = OFF, 1 = ON

    always @(posedge clk) begin
        if (reset)
            state <= 1'b0; // OFF
        else
            state <= state ? (k ? 1'b0 : 1'b1) : (j ? 1'b1 : 1'b0);
    end

    assign out = state;

endmodule