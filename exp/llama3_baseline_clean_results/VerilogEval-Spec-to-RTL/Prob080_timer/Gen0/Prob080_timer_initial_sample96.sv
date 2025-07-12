module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output tc
);

reg [9:0] counter; // internal counter
assign tc = (counter == 10'd0); // assert tc when counter reaches 0

always @(posedge clk) // sequential logic triggered on positive clock edge
begin
    if (load) // load counter with data when load is high
        counter <= data;
    else if (counter != 10'd0) // decrement counter when load is low and counter is not 0
        counter <= counter - 1'd1;
end

endmodule