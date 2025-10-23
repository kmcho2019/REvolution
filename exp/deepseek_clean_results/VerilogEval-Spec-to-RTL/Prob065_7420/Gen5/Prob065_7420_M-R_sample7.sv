module TopModule (
    input p1a,
    input p1b,
    input p1c,
    input p1d,
    input p2a,
    input p2b,
    input p2c,
    input p2d,
    output reg p1y,
    output reg p2y
);

    // Using always blocks for combinational logic
    always @(*) begin
        p1y = ~(p1a & p1b & p1c & p1d);
    end

    always @(*) begin
        p2y = ~(p2a & p2b & p2c & p2d);
    end

endmodule