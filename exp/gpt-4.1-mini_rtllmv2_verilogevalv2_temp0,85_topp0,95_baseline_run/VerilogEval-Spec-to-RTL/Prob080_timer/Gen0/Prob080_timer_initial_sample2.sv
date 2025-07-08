module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output tc
);

// Internal 10-bit register implemented as a single D flip-flop with 10 bits width
reg [9:0] counter;

// Next value for the counter
wire [9:0] counter_next;

// Determine if counter is zero (terminal count)
assign tc = (counter == 10'd0);

// Combinational logic for next counter value
assign counter_next = load ? data : (counter == 10'd0 ? 10'd0 : counter - 10'd1);

// Sequential logic: update counter on posedge clk
always @(posedge clk) begin
    counter <= counter_next;
end

endmodule