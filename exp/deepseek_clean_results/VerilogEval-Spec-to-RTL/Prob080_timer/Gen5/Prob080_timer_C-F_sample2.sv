module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] counter;

    always @(posedge clk) begin
        counter <= load ? data : (counter == 0) ? counter : counter - 1;
    end

    assign tc = ~|counter;  // OR reduction for efficient zero detection

endmodule