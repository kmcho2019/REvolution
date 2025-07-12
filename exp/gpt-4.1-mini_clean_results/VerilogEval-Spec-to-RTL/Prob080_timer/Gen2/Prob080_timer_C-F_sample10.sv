module TopModule (
    input        clk,
    input        load,
    input  [9:0] data,
    output       tc
);

    reg [9:0] counter;

    always @(posedge clk) begin
        if (load) begin
            counter <= data;
        end else if (|counter) begin
            counter <= counter - 10'd1;
        end
        // else counter holds zero, no redundant assignment
    end

    // Terminal count is asserted when counter is zero (no bits set)
    assign tc = ~|counter;

endmodule