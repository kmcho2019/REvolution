module TopModule (
    input  clk,
    input  L,
    input  q_in,
    input  r_in,
    output reg Q
);

    reg d;

    always @(posedge clk) begin
        if (L) begin
            d = r_in;
        end else begin
            d = q_in;
        end
        Q <= d;
    end

endmodule