module TopModule (
    input  clk,
    input  areset,
    input  x,
    output z
);

reg [31:0] acc;  // Accumulator to store input bits
reg [31:0] sign;  // Register to store the sign bit (most significant bit)
reg msb_encountered;  // Flag to track whether most significant bit has been encountered
reg [31:0] counter;  // Counter to track the number of bits

always @(posedge clk or posedge areset) begin
    if (areset) begin
        acc <= 0;
        sign <= 0;
        msb_encountered <= 0;
        counter <= 0;
        z <= 0;
    end else begin
        if (~msb_encountered) begin
            acc <= {acc[30:0], x};  // Shift left and add new bit
            counter <= counter + 1;
            if (x == 1) begin
                sign <= 1;  // Set sign bit if most significant bit is 1
                msb_encountered <= 1;
            end
        end
        if (msb_encountered) begin
            if (sign) begin
                acc <= acc + 1;  // Add 1 to get 2's complement
            end
            z <= ~acc[0];  // Output the least significant bit of the result
            acc <= {acc[30:0], 1'b0};  // Shift left and add 0
        end
    end
end

endmodule