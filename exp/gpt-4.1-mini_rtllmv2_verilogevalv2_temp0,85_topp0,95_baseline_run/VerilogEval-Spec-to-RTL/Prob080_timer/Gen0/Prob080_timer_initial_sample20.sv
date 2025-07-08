module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);
    reg [9:0] counter;

    // Terminal count is asserted when counter is zero
    assign tc = (counter == 10'd0);

    always @(posedge clk) begin
        if (load)
            counter <= data;
        else if (counter != 10'd0)
            counter <= counter - 10'd1;
        // else counter remains zero
    end
endmodule