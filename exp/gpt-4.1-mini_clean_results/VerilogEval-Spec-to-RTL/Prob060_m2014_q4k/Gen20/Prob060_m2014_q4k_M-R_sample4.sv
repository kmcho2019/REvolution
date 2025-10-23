module TopModule (
    input  wire clk,
    input  wire resetn,
    input  wire in,
    output wire out
);
    reg q0, q1, q2, q3;

    // First flip-flop
    always @(posedge clk) begin
        if (~resetn)
            q0 <= 1'b0;
        else
            q0 <= in;
    end

    // Second flip-flop
    always @(posedge clk) begin
        if (~resetn)
            q1 <= 1'b0;
        else
            q1 <= q0;
    end

    // Third flip-flop
    always @(posedge clk) begin
        if (~resetn)
            q2 <= 1'b0;
        else
            q2 <= q1;
    end

    // Fourth flip-flop
    always @(posedge clk) begin
        if (~resetn)
            q3 <= 1'b0;
        else
            q3 <= q2;
    end

    assign out = q3;
endmodule