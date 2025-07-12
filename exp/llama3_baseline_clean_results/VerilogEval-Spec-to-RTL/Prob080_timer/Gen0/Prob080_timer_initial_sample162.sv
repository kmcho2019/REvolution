module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

reg [9:0] counter; // internal counter

always @(posedge clk) begin
    if (load) begin // load new value
        counter <= data;
    end else if (counter > 0) begin // decrement counter
        counter <= counter - 1;
    end
end

assign tc = (counter == 0); // assert tc when counter reaches 0

endmodule