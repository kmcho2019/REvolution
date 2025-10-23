module TopModule (
    input clk,
    input x,
    output reg z
);

    reg [2:0] shift_reg;  // [xor, and, or]
    reg initialized;
    
    // Combinational logic for gate outputs
    wire xor_out = x ^ shift_reg[2];      // XOR with its own state
    wire and_out = x & ~shift_reg[1];     // AND with complemented state
    wire or_out  = x | ~shift_reg[0];     // OR with complemented state
    
    always @(posedge clk) begin
        if (!initialized) begin
            // Initialization sequence
            shift_reg <= 3'b000;
            initialized <= 1'b1;
        end else begin
            // Parallel load of all gate outputs
            shift_reg <= {xor_out, and_out, or_out};
        end
        
        // Output is NOR of all flip-flop states
        z <= ~(|shift_reg);
    end

endmodule