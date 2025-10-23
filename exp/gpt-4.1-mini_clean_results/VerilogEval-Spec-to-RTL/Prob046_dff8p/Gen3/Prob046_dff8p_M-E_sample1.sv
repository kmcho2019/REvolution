module TopModule (
    input        clk,
    input        reset,
    input  [7:0] d,
    output reg [7:0] q
);

    // Bit 0
    always @(negedge clk) begin
        if (reset)
            q[0] <= 1'b0;  // bit 0 of 0x34 (0b00110100) is 0
        else
            q[0] <= d[0];
    end

    // Bit 1
    always @(negedge clk) begin
        if (reset)
            q[1] <= 1'b0;  // bit 1 of 0x34 is 0
        else
            q[1] <= d[1];
    end

    // Bit 2
    always @(negedge clk) begin
        if (reset)
            q[2] <= 1'b1;  // bit 2 of 0x34 is 1
        else
            q[2] <= d[2];
    end

    // Bit 3
    always @(negedge clk) begin
        if (reset)
            q[3] <= 1'b0;  // bit 3 of 0x34 is 0
        else
            q[3] <= d[3];
    end

    // Bit 4
    always @(negedge clk) begin
        if (reset)
            q[4] <= 1'b1;  // bit 4 of 0x34 is 1
        else
            q[4] <= d[4];
    end

    // Bit 5
    always @(negedge clk) begin
        if (reset)
            q[5] <= 1'b1;  // bit 5 of 0x34 is 1
        else
            q[5] <= d[5];
    end

    // Bit 6
    always @(negedge clk) begin
        if (reset)
            q[6] <= 1'b0;  // bit 6 of 0x34 is 0
        else
            q[6] <= d[6];
    end

    // Bit 7
    always @(negedge clk) begin
        if (reset)
            q[7] <= 1'b0;  // bit 7 of 0x34 is 0
        else
            q[7] <= d[7];
    end

endmodule