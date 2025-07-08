module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output tc
);
    reg [9:0] counter;
    reg tc_reg;

    always @(posedge clk) begin
        if (load)
            counter <= data;
        else if (counter != 10'd0)
            counter <= counter - 10'd1;

        tc_reg <= (counter == 10'd0);
    end

    assign tc = tc_reg;

endmodule