module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

    wire enable_bit1;
    wire enable_bit2;
    wire enable_bit3;

    assign enable_bit1 = q[0];
    assign enable_bit2 = q[0] & q[1];
    assign enable_bit3 = q[0] & q[1] & q[2];

    // Bit 0
    always @(posedge clk) begin
        if (reset)
            q[0] <= 1'b0;
        else
            q[0] <= ~q[0];
    end

    // Bit 1
    always @(posedge clk) begin
        if (reset)
            q[1] <= 1'b0;
        else if (enable_bit1)
            q[1] <= ~q[1];
    end

    // Bit 2
    always @(posedge clk) begin
        if (reset)
            q[2] <= 1'b0;
        else if (enable_bit2)
            q[2] <= ~q[2];
    end

    // Bit 3
    always @(posedge clk) begin
        if (reset)
            q[3] <= 1'b0;
        else if (enable_bit3)
            q[3] <= ~q[3];
    end

endmodule