module TopModule (
    input clk,
    input reset,
    output reg [9:0] q
);

    // Using combinational logic to detect terminal count (999)
    wire terminal_count;

    // Since 999 decimal = 10'b 1111100111 (0x3E7)
    // We check if q == 999 by comparing bits accordingly.
    // This is split to reduce comparator complexity.

    assign terminal_count = (q[9:7] == 3'b111) && // bits 9,8,7 = 111 (7 decimal)
                            (q[6:4] == 3'b110) && // bits 6,5,4 = 110 (6 decimal)
                            (q[3:0] == 4'b0111);  // bits 3-0 = 0111 (7 decimal)

    always @(posedge clk) begin
        if (reset)
            q <= 0;
        else if (terminal_count)
            q <= 0;
        else
            q <= q + 1;
    end

endmodule