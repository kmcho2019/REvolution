module LFSR(
    input clk,
    input rst,
    output reg [3:0] out
);

always @ (posedge clk) begin
    if (rst) begin
        // Initialize LFSR state to zero on reset
        out <= 4'd0;
    end else begin
        // Calculate feedback signal
        reg feedback;
        feedback = ~(out[3] ^ out[2]);
        
        // Shift bits to the left and insert feedback at LSB
        out <= {out[2:0], feedback};
    end
end

endmodule