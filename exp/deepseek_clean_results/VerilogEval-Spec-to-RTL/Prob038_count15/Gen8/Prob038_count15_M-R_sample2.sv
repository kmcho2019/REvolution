module TopModule (
    input clk,
    input reset,
    output [3:0] q
);

reg [3:0] current_state;
wire [3:0] next_state;

// Combinational increment logic
assign next_state = current_state + 1'b1;

// Sequential state register
always @(posedge clk) begin
    if (reset) current_state <= 4'b0000;
    else current_state <= next_state;
end

// Output assignment
assign q = current_state;

endmodule