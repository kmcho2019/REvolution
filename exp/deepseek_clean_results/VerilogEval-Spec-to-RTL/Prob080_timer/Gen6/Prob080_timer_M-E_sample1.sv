module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output tc
);

reg [9:0] shift_counter;

always @(posedge clk) begin
    if (load) begin
        // Load the data by setting bits to '1' where needed
        shift_counter <= data;
    end
    else if (shift_counter != 0) begin
        // Shift right to decrement (with zero fill from left)
        shift_counter <= {1'b0, shift_counter[9:1]};
    end
end

// Terminal count is when LSB is 1 (or all zeros)
assign tc = (shift_counter == 0) || (shift_counter[0] == 1'b1);

endmodule