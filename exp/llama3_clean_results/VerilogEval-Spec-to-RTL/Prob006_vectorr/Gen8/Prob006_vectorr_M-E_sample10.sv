// Module to reverse the bit ordering of an 8-bit input using a shift register approach
module TopModule(
    input  clk,       // Clock signal
    input  rst_n,     // Active low reset
    input  [7:0] in,  // 8-bit input vector
    output [7:0] out  // 8-bit output vector
);

    reg [7:0] shift_reg; // Internal shift register
    reg [2:0] counter;   // Counter to track the shift operations

    // Initialize the shift register and counter on reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift_reg <= 8'b0;
            counter <= 3'b0;
        end else begin
            // Load the input into the shift register on the first clock cycle
            if (counter == 3'b0) begin
                shift_reg <= in;
                counter <= counter + 1'b1;
            end else if (counter < 3'b100) begin
                // Shift the bits one position to the right ( effectively reversing the order )
                shift_reg <= {shift_reg[6:0], shift_reg[7]};
                counter <= counter + 1'b1;
            end
        end
    end

    // Output the reversed bits after the shifting process is complete
    always @(*) begin
        if (counter == 3'b100) begin
            out <= shift_reg;
        end else begin
            out <= 8'b0; // Default output until the reversal is complete
        end
    end

endmodule