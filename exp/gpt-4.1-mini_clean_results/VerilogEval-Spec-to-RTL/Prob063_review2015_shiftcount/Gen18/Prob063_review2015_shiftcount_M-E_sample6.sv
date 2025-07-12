module TopModule(
    input         clk,
    input         shift_ena,
    input         count_ena,
    input         data,
    output reg [3:0] q
);

    // Shift operation: shift left, input data at LSB on shift_ena
    always @(posedge clk) begin
        if (shift_ena) begin
            q <= {q[2:0], data};
        end
    end

    // Count operation: decrement q by 1 on count_ena
    always @(posedge clk) begin
        if (count_ena) begin
            q <= q - 4'd1;
        end
    end

    // If neither enable is high, q holds its value implicitly (no assignment needed)
    // Since shift_ena and count_ena never asserted simultaneously, this logic is well-defined

endmodule