module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

    reg state;
    wire clk_en = (state ? k : j) | reset;  // Clock gating condition

    always @(posedge clk) begin
        if (reset) begin
            state <= 1'b0;
        end else if (state) begin
            state <= ~k;  // ON state transition
        end else begin
            state <= j;   // OFF state transition
        end
    end

    assign out = state;

endmodule