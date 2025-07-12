// Module to reverse the bit ordering of an 8-bit input using shift registers
module TopModule(
    input  clk,       // Clock signal
    input  rst_n,     // Active-low reset signal
    input  [7:0] in,  // 8-bit input vector
    output [7:0] out  // 8-bit output vector
);

    reg [7:0] shift_reg;  // Shift register to hold the input bits
    reg [2:0] counter;   // Counter to control the shifting process

    // Initialize the shift register and counter
    initial begin
        shift_reg = 8'd0;
        counter = 3'd0;
    end

    // Shift in the input bits and then shift them out in reverse order
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            shift_reg <= 8'd0;
            counter <= 3'd0;
        end else begin
            if (counter == 3'd0) begin
                // Shift in the input bits
                shift_reg <= in;
                counter <= counter + 1'd1;
            end else if (counter == 3'd8) begin
                // Shift out the bits in reverse order
                out <= {shift_reg[0], shift_reg[1], shift_reg[2], shift_reg[3], shift_reg[4], shift_reg[5], shift_reg[6], shift_reg[7]};
                counter <= 3'd0;
            end else begin
                // Continue shifting out the bits
                counter <= counter + 1'd1;
            end
        end
    end

endmodule