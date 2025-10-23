module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

reg [9:0] count;

always @(posedge clk) begin
    if (load) begin
        count <= data; // load the counter with the new data when load is high
    end else if (count > 0) begin
        count <= count - 1; // decrement the counter when load is low and count is greater than 0
    end
end

assign tc = (count == 0); // assert tc when the counter reaches 0

initial begin
    count <= 0; // initialize the counter to 0
end

endmodule