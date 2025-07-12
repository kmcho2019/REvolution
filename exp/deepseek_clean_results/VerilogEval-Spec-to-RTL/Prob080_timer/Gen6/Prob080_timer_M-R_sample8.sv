module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output tc
);

reg [9:0] counter;
wire [9:0] next_counter;

assign next_counter = load ? data : (|counter) ? (counter - 1) : counter;
assign tc = ~|counter;

always @(posedge clk) begin
    counter <= next_counter;
end

endmodule