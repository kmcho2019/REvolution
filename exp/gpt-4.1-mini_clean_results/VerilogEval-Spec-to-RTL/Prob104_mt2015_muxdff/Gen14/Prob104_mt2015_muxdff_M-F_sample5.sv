module TopModule (
    input  clk,
    input  L,
    input  q_in,
    input  r_in,
    output reg Q
);

    reg d;

    always @(posedge clk) begin
        d = L ? r_in : q_in;
        Q <= d;
    end

endmodule