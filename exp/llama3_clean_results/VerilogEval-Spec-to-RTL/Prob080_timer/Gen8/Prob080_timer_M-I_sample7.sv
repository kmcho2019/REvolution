module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

reg [9:0] counter;

// Simplified combinational logic for next state
always @(*) begin
    if (load) begin
        counter <= data;
    end else if (counter!= 10'd0) begin
        counter <= counter - 1;
    end
end

// Sequential logic to update counter is replaced by combinational logic above
// Combinational logic to assert tc remains the same
assign tc = (counter == 10'd0)? 1'b1 : 1'b0;

endmodule