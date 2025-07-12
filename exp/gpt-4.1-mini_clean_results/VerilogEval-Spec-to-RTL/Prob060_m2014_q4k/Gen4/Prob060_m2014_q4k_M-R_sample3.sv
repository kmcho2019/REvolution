module TopModule (
    input clk,
    input resetn,
    input in,
    output out
);
    reg q0, q1, q2, q3;

    always @(posedge clk) begin
        if (!resetn)
            q0 <= 1'b0;
        else
            q0 <= in;
    end

    always @(posedge clk) begin
        if (!resetn)
            q1 <= 1'b0;
        else
            q1 <= q0;
    end

    always @(posedge clk) begin
        if (!resetn)
            q2 <= 1'b0;
        else
            q2 <= q1;
    end

    always @(posedge clk) begin
        if (!resetn)
            q3 <= 1'b0;
        else
            q3 <= q2;
    end

    assign out = q3;
endmodule