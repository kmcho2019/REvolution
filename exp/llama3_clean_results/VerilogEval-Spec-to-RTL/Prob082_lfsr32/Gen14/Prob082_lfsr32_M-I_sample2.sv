module TopModule(
    input  clk,
    input  reset,
    output reg [31:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 32'h1;
    end else begin
        // Calculate new LSB based on taps
        reg lsb_new;
        lsb_new = q[0] ^ q[31] ^ q[21] ^ q[1];
        
        // Shift right and update LSB
        q <= {q[30:0], lsb_new};
    end
end

endmodule