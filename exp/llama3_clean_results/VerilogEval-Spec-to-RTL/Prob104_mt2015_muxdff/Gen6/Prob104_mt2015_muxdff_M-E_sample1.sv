module TopModule (
    input  clk,
    input  L,
    input  q_in,
    input  r_in,
    output Q
);

    reg q;

    always @(posedge clk) begin
        q <= L ? r_in : q_in;
    end

    assign Q = q;

endmodule