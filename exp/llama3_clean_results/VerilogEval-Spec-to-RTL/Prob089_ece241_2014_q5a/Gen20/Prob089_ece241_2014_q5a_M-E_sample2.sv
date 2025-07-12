module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg [7:0] shift_reg; // Assuming 8-bit shift register for demonstration
reg [2:0] counter; // Counter to track the number of bits received
reg [7:0] result; // Register to store the result of 2's complement conversion

always @(posedge clk or posedge areset) begin
    if (areset) begin
        shift_reg <= 8'b0;
        counter <= 3'b0;
        result <= 8'b0;
    end else begin
        // Store incoming bits in shift register
        shift_reg <= {shift_reg[6:0], x};

        // Increment counter for each incoming bit
        counter <= counter + 1;

        // Perform 2's complement conversion when reset is asserted again
        if (counter == 8) begin // Assuming 8-bit input for demonstration
            result <= ~(shift_reg) + 1;
        end
    end
end

always @(posedge clk) begin
    // Generate output serially, bit by bit
    if (counter == 8) begin // Assuming 8-bit input for demonstration
        z <= result[7];
        result <= result << 1;
        counter <= counter - 1;
    end
end

endmodule