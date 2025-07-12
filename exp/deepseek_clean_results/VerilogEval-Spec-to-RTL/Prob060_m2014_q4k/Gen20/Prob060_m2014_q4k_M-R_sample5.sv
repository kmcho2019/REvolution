module TopModule (
    input clk,
    input resetn,
    input in,
    output out
);

    wire d0, d1, d2, d3;
    reg q0, q1, q2, q3;

    // First stage
    assign d0 = in;
    always @(posedge clk) begin
        if (!resetn) q0 <= 1'b0;
        else q0 <= d0;
    end

    // Second stage
    assign d1 = q0;
    always @(posedge clk) begin
        if (!resetn) q1 <= 1'b0;
        else q1 <= d1;
    end

    // Third stage
    assign d2 = q1;
    always @(posedge clk) begin
        if (!resetn) q2 <= 1'b0;
        else q2 <= d2;
    end

    // Fourth stage
    assign d3 = q2;
    always @(posedge clk) begin
        if (!resetn) q3 <= 1'b0;
        else q3 <= d3;
    end

    assign out = q3;

endmodule