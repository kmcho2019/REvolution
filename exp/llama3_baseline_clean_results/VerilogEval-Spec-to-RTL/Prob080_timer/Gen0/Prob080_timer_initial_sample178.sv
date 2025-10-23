module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

reg [9:0] count; // internal 10-bit counter

always @(posedge clk) begin
    if (load) begin
        count <= data; // load the counter with the input data
        tc <= 1'b0; // reset the terminal count signal
    end else if (count > 0) begin
        count <= count - 1; // decrement the counter
        tc <= 1'b0; // reset the terminal count signal
    end else begin
        tc <= 1'b1; // assert the terminal count signal when the counter reaches 0
    end
end

endmodule