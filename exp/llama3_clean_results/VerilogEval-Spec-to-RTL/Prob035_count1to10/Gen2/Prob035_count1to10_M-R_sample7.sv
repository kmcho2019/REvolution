module TopModule(
    input  clk,
    input  reset,
    output [3:0] q
);

reg [3:0] count;

// Sequential logic to update the count
always @(posedge clk) begin
    if (reset) begin
        count <= 4'd1;
    end else if (count == 4'd10) begin
        count <= 4'd1;
    end else begin
        count <= count + 4'd1;
    end
end

// Combinational logic (not actually needed in this simple case, 
// but shown for illustration of a more complex state machine)
// assign q = count;

// Directly assign the count to output q
assign q = count;

endmodule