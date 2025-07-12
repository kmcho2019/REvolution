module TopModule (
    input  clk,
    input  L,
    input  q_in,
    input  r_in,
    output reg Q
);

    reg internal_Q;

    always @(posedge clk) begin
        internal_Q <= L ? r_in : q_in;
    end

    assign Q = internal_Q;

endmodule