module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output out
);
    reg state; // 0=OFF, 1=ON

    always @(posedge clk) begin
        state <= reset ? 1'b0 :
                 (state == 1'b0) ? j :
                 ~k;
    end

    assign out = state;

endmodule