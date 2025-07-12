module LFSR(
    input clk,
    input rst,
    output reg [3:0] out
);

    // Internal register to store the current state
    reg [3:0] internal_reg;

    // Procedural block to handle clock edge and reset
    always @(posedge clk) begin
        if (rst) begin
            // Initialize the register to zero on reset
            internal_reg <= 4'b0000;
        end else begin
            // Calculate the feedback signal by XORing the most significant bit and the second most significant bit
            reg feedback;
            feedback = ~(internal_reg[3] ^ internal_reg[2]);
            
            // Shift the bits in the register left and insert the new feedback value at the LSB
            internal_reg <= {internal_reg[2:0], feedback};
        end
    end

    // Continuous assignment to output the current state of the internal register
    assign out = internal_reg;

endmodule