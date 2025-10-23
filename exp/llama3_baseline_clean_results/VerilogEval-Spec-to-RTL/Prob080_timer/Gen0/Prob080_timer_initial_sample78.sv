module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output reg tc
);

reg [9:0] counter; // internal counter

always @(posedge clk) begin
    if (load) begin
        counter <= data; // load the counter with the input data
        tc <= 1'b0; // reset tc when loading
    end else if (counter > 0) begin
        counter <= counter - 1; // decrement the counter
        tc <= 1'b0; // tc is 0 while counting
    end else begin
        tc <= 1'b1; // tc is 1 when counter reaches 0
    end
end

endmodule