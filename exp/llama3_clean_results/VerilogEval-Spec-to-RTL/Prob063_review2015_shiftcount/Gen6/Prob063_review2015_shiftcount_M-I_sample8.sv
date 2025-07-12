module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output [3:0] q
);

// Register to hold the current value
reg [3:0] counter;

// Initialize the register
initial begin
    counter = 4'b0000;
end

// Update the counter register
always @(posedge clk) begin
    if (shift_ena) begin
        // Shift the data into the counter register (most-significant-bit first)
        counter <= {data, counter[3:1]};
    end else if (count_ena) begin
        // Decrement the counter
        if (counter == 4'b0000) begin
            counter <= 4'b0000; // Stay at zero when decrementing from zero
        end else begin
            counter <= counter - 1;
        end
    end
end

// Assign the value of counter to output q
assign q = counter;

endmodule