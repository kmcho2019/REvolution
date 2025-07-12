module TopModule(
    input  clk,
    input  areset,
    input  x,
    output z
);

reg [31:0] sum; // Internal register to store the running sum
reg [0:0] state; // 1-bit state register, Idle (0) and Running (1)
reg [0:0] z_reg; // Register to store the output

initial state = 0; // Initialize the state to Idle
initial sum = 0; // Initialize the sum to 0
initial z_reg = 0; // Initialize the output to 0

always @(posedge clk or posedge areset) begin
    if(areset) begin // Asynchronous reset
        state <= 0; // Go back to Idle state on reset
        sum <= 0; // Reset the sum
        z_reg <= 0; // Reset the output
    end else if(state == 0 && areset == 1'b0) begin // Transition from Idle to Running
        state <= 1; // Go to Running state when reset is released
    end
end

always @(posedge clk) begin
    if(state == 1 && areset == 1'b0) begin // In Running state and not in reset
        sum <= sum + x; // Accumulate the input bits
        if(sum % 2 == 1) begin // If the sum is odd, output the inverse of the input bit
            z_reg <= ~x;
        end else begin // If the sum is even, output the input bit itself
            z_reg <= x;
        end
        if(areset) begin // If reset is asserted while in Running state
            state <= 0; // Go back to Idle state
        end
    end
end

assign z = z_reg; // Output the registered output

endmodule