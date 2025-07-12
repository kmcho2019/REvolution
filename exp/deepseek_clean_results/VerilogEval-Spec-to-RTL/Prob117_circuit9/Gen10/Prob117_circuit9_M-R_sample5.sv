module TopModule (
    input clk,
    input a,
    output [2:0] q
);

reg [2:0] counter;
wire [2:0] next_counter;

// Combinational logic for next counter value
assign next_counter = a ? 3'b100 : 
                     (counter == 3'b110) ? 3'b000 : 
                     counter + 1;

// Sequential update
always @(posedge clk) begin
    counter <= next_counter;
end

// Output assignment
assign q = counter;

endmodule