module TopModule(
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

    always @(*) begin
        // Count the number of 1s for the first set of inputs
        if (p1a + p1b + p1c + p1d == 4) begin
            p1y = 0;
        end else begin
            p1y = 1;
        end
        
        // Count the number of 1s for the second set of inputs
        if (p2a + p2b + p2c + p2d == 4) begin
            p2y = 0;
        end else begin
            p2y = 1;
        end
    end

endmodule