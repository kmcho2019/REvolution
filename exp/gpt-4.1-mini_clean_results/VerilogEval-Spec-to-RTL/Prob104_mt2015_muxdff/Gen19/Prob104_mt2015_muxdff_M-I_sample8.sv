module TopModule (
    input  clk,
    input  L,
    input  q_in,
    input  r_in,
    output reg Q
);

    reg mux_out;

    always @(*) begin
        mux_out = L ? r_in : q_in;
    end

    always @(posedge clk) begin
        Q <= mux_out;
    end

endmodule