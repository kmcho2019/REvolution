module TopModule (
    input  clk,
    input  L,
    input  q_in,
    input  r_in,
    output reg Q
);

    always @(posedge clk) begin
        reg next_val;
        next_val = L ? r_in : q_in;
        Q <= next_val;
    end

endmodule