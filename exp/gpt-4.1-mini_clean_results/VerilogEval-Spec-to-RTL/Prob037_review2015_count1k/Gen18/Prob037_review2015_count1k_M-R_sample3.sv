module TopModule (
    input clk,
    input reset,
    output [9:0] q
);

    localparam MAX_COUNT = 10'd999;

    reg [9:0] count_reg, count_next;

    // Next state logic
    always @(*) begin
        if (count_reg == MAX_COUNT)
            count_next = 10'd0;
        else
            count_next = count_reg + 10'd1;
    end

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            count_reg <= 10'd0;
        else
            count_reg <= count_next;
    end

    // Output assignment
    assign q = count_reg;

endmodule