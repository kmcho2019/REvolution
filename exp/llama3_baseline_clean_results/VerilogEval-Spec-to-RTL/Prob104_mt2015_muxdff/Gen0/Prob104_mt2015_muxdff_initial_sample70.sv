module TopModule (
    input clk,
    input L,
    input q_in,
    input r_in,
    output Q
);

    reg q;

    always @(posedge clk) begin
        if (L) begin
            q <= q_in;
        end else begin
            q <= q_in ^ r_in;
        end
    end

    assign Q = q;

endmodule