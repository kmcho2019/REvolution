module TopModule (
    input  clk,
    input  L,
    input  r_in,
    output reg Q
);

    always @(posedge clk) begin
        Q <= L ? r_in : Q;
    end

endmodule