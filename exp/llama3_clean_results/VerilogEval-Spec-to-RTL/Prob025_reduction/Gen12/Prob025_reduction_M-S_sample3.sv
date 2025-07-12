// Simplified module to calculate the even parity bit for an 8-bit input byte using a loop
module TopModule(
    input  [7:0] in,  // 8-bit input byte
    output parity    // 1-bit output for even parity
);

// Initialize the parity bit
reg parity_temp;
initial parity_temp = 1'b0;

// Calculate the even parity bit using a loop
always @(*) begin
    parity_temp = 1'b0;
    for (int i = 0; i < 8; i++) begin
        parity_temp = parity_temp ^ in[i];
    end
end

// Assign the calculated parity to the output
assign parity = parity_temp;

endmodule