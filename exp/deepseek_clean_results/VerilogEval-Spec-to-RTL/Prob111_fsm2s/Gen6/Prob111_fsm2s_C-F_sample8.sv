module TopModule (
    input clk,
    input reset,
    input j,
    input k,
    output out
);

    reg state;  // 0 = OFF, 1 = ON

    always @(posedge clk) begin
        if (reset) begin
            state <= 1'b0;  // Reset to OFF
        end else if (state) begin
            state <= ~k;    // ON state: k=1->OFF (0), k=0->ON (1)
        end else begin
            state <= j;     // OFF state: j=1->ON (1), j=0->OFF (0)
        end
    end

    assign out = state;

endmodule