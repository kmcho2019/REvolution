module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

reg [9:0] count; // internal counter

always @(posedge clk) begin
    if (load) begin
        // load the counter with the input data
        count <= data;
    end else if (count > 0) begin
        // decrement the counter
        count <= count - 1;
    end
end

// generate the tc signal
assign tc = (count == 0) &&!load;

endmodule