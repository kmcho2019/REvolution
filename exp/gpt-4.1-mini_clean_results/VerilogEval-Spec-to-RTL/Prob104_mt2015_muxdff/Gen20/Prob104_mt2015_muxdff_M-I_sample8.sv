module TopModule (
    input  clk,
    input  L,
    input  q_in,  // next state bit when not loading (d_in)
    input  r_in,  // load bit
    output reg Q
);

    always @(posedge clk) begin
        if (L) begin
            Q <= r_in;
        end else begin
            Q <= q_in;
        end
    end

endmodule