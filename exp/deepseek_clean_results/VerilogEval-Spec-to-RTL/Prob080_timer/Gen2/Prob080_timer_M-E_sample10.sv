module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] shift_counter;

    always @(posedge clk) begin
        if (load) begin
            // Load thermometer code: data[9:0] 1's followed by 0's
            shift_counter <= {10{1'b1}} >> (10 - data);
        end else if (|shift_counter) begin
            // Right shift to count down (MSB gets 0)
            shift_counter <= {1'b0, shift_counter[9:1]};
        end
    end

    // Terminal count is when LSB becomes 0
    assign tc = ~shift_counter[0];

endmodule