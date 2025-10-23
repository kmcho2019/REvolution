module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] counter = 0;
    assign tc = ~|counter;  // NOR reduction for zero detection

    always @(posedge clk) begin
        counter <= load ? data : (tc ? 0 : counter - 1);
    end

endmodule