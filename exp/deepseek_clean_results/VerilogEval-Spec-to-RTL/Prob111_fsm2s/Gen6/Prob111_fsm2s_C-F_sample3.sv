module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

    reg state;  // 0=OFF (out=0), 1=ON (out=1)

    always @(posedge clk) begin
        if (reset) begin
            state <= 1'b0;  // Synchronous reset to OFF
        end
        else if (state) begin  // Current state is ON
            state <= ~k;      // Stay ON if k=0, go OFF if k=1
        end
        else begin           // Current state is OFF
            state <= j;      // Stay OFF if j=0, go ON if j=1
        end
    end

    assign out = state;  // Moore output directly from state

endmodule