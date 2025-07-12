module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output tc
);

reg [9:0] counter;

always @(posedge clk) begin
    counter <= load ? data : (|counter) ? (counter - 1) : counter;
end

assign tc = ~|counter;

endmodule