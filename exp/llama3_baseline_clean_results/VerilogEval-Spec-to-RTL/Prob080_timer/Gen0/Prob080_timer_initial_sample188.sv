module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output tc
);

reg [9:0] counter; // internal counter

always @(posedge clk) begin
    if (load) begin
        counter <= data; // load counter with input data
    end else if (counter > 0) begin
        counter <= counter - 1; // decrement counter
    end
end

assign tc = (counter == 0) && !load; // assert tc when counter reaches 0

endmodule