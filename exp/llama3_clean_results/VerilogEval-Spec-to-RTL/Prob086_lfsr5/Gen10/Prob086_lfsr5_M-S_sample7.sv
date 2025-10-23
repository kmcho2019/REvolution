module TopModule(
    input clk,
    input reset,
    output reg [4:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 5'b00001; // Reset the LFSR output to 1
    end else begin
        q <= {q[2] ^ q[0], q[4:1]}; // Update q by shifting right and XORing q[2] and q[0] for the new MSB
    end
end

endmodule