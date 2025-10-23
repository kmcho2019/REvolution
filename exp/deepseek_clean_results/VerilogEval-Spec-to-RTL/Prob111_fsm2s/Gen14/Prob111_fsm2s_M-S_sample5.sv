module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

    reg state; // 0=OFF, 1=ON

    always @(posedge clk) begin
        state <= reset ? 1'b0 : 
                (state ? (k ? 1'b0 : 1'b1) :  // if ON
                (j ? 1'b1 : 1'b0);            // if OFF
    end

    assign out = state;

endmodule