module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] counter;
    assign tc = (counter == 0);

    always @(posedge clk) begin
        counter <= load ? data : (tc ? counter : counter - 1);
    end

endmodule