module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output [3:0] q
);

reg [3:0] counter;
wire [3:0] next_counter;

// Calculate the next state of the counter
assign next_counter = (shift_ena) ? {data, counter[3:1]} : 
                      (count_ena && counter != 4'b0) ? (counter - 1) : counter;

// Update the counter on the positive edge of the clock
always @(posedge clk) begin
    counter <= next_counter;
end

assign q = counter;

endmodule