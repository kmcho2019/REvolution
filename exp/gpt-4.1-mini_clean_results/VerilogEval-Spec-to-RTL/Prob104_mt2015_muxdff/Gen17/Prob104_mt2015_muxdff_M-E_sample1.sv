module TopModule (
    input  clk,
    input  L,
    input  q_in,
    input  r_in,
    input  comp_in,
    output reg Q
);

    always @(posedge clk) begin
        if (L)
            Q <= r_in;
        else
            Q <= comp_in;
    end

endmodule