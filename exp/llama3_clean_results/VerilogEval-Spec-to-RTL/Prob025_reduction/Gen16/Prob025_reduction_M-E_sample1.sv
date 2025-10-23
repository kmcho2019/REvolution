// Novel module to calculate the even parity bit for an 8-bit input byte
module TopModule(
    input  [7:0] in,  // 8-bit input byte
    output parity    // 1-bit output for even parity
);

// Initialize the parity bit to 0 (assuming even parity)
reg parity_reg;
initial parity_reg = 1'b0;

// Calculate the even parity bit using a sequential XOR operation
always @(in) begin
    parity_reg = 1'b0;
    for (int i = 0; i < 8; i++) begin
        parity_reg = parity_reg ^ in[i];
    end
end

// Assign the calculated parity to the output
assign parity = parity_reg;

endmodule