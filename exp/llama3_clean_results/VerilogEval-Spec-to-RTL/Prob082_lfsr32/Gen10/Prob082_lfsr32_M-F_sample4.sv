module TopModule(
    input  clk,
    input  reset,
    output reg [31:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 32'h1;
    end else begin
        // Calculate the new MSB by XORing the taps with the current LSB
        reg [31:0] new_q;
        reg feedback = q[21] ^ q[1] ^ q[0];
        
        // Shift the register to the right and insert the new MSB
        new_q = {feedback, q[31:1]};
        
        q <= new_q;
    end
end

endmodule