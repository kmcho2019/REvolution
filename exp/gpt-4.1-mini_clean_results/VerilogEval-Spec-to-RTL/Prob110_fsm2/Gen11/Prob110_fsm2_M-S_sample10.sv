module TopModule(
    input clk,
    input areset,
    input j,
    input k,
    output out
);

    reg state;

    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b0;          // OFF state
        else
            state <= state ? (k ? 1'b0 : 1'b1) : (j ? 1'b1 : 1'b0);
    end

    assign out = state;

endmodule