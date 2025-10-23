module TopModule(
    input  clk,
    input  reset,
    output reg [31:0] q
);

// Define the tap positions
parameter TAP_1 = 31;
parameter TAP_2 = 21;
parameter TAP_3 = 1;
parameter TAP_4 = 0;

// Update the LFSR state
always @(posedge clk or posedge reset) begin
    if (reset) begin
        q <= 32'h1;
    end else begin
        reg [31:0] next_q;
        // Shift the register to the right
        next_q = {q[30:0], 1'b0};
        
        // XOR the bits at the tap positions with the LSB
        next_q[TAP_1] = q[TAP_1] ^ q[TAP_4];
        next_q[TAP_2] = q[TAP_2] ^ q[TAP_4];
        next_q[TAP_3] = q[TAP_3] ^ q[TAP_4];
        
        // Update the LFSR state
        q <= next_q;
    end
end

endmodule