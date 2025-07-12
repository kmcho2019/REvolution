module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] shift_reg;

    // Combinational load logic: create a one-hot vector with '1' at the position of data
    // If data is zero, load zero to indicate terminal count immediately
    wire [9:0] load_pattern;

    // Create a one-hot pattern: bit at position (data-1) is set to 1 (counting from MSB=bit9 to LSB=bit0)
    // Since data is number of cycles, with data=1 means the LSB bit is set,
    // data=10 means bit9 is set. So load_pattern = 1 << (data - 1)
    // Handle data=0 (load zero)
    wire [3:0] index = (data == 0) ? 4'd0 : (data - 1);

    assign load_pattern = (data == 0) ? 10'b0 : (10'b1 << index);

    always @(posedge clk) begin
        if (load) begin
            shift_reg <= load_pattern;
        end else if (shift_reg != 0) begin
            shift_reg <= shift_reg >> 1;
        end
        // else shift_reg is zero, remain zero until next load
    end

    // Terminal count is asserted when shift_reg is zero (count reached),
    // or shift_reg LSB is '1' (count about to reach zero next cycle)
    // But since we shift when shift_reg != 0, the terminal count is when shift_reg == 0
    assign tc = (shift_reg == 0);

endmodule