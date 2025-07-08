module TopModule (
    input clk,
    input L,
    input q_in,
    input r_in,
    output reg Q
);
    always @(posedge clk) begin
        if (r_in)
            Q <= 0;
        else if (L)
            Q <= q_in;
        // else retain Q
    end
endmodule