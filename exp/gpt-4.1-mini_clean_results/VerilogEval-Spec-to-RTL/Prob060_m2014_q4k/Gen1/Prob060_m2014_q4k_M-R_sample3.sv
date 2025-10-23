module TopModule (
    input clk,
    input resetn,
    input in,
    output out
);

    reg q0, q1, q2, q3;

    always @(posedge clk) begin
        if (~resetn) begin
            q0 <= 1'b0;
            q1 <= 1'b0;
            q2 <= 1'b0;
            q3 <= 1'b0;
        end else begin
            q0 <= in;
            q1 <= q0;
            q2 <= q1;
            q3 <= q2;
        end
    end

    assign out = q3;

endmodule