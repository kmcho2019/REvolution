module right_shifter(
    input clk,  // Clock signal
    input d,   // Input signal to be right-shifted
    output [7:0] q  // Output signal representing the result of the right shift operation
    );

reg [7:0] q_reg;  // Register to store the shifted value
assign q = q_reg;  // Continuously assign the value of q_reg to q

initial
    q_reg = 8'b0;  // Initialize q_reg to 0

always @(posedge clk)  // On each rising edge of the clock
    begin
        q_reg = {d, q_reg[7:1]};  // Right-shift q_reg by 1 bit and insert d into the most significant position
    end

endmodule