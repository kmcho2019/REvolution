module TopModule (
    input        clk,
    input        reset,
    output reg [4:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            q <= 5'b00001; // synchronous reset to 1
        end else begin
            // Update LFSR bits directly, referencing current q without temp vars
            q[0] <= q[1];
            q[1] <= q[2];
            q[2] <= q[3] ^ q[0]; // tap at bit 3 XOR with feedback bit q[0]
            q[3] <= q[4];
            q[4] <= q[0];        // tap at bit 5 replaced with feedback bit q[0]
        end
    end

endmodule