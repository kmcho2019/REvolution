module TopModule(
    input clk,
    input reset,
    output reg [4:0] q
);

    always @(posedge clk or posedge reset) begin
        if(reset) begin
            q <= 5'b10000; // Reset to 1, assuming most significant bit is q[4]
        end else begin
            q[4] <= q[3];
            q[3] <= q[2];
            q[2] <= q[1];
            q[1] <= q[0];
            q[0] <= q[4] ^ q[2] ^ q[0]; // XOR tap positions 5 and 3 with LSB
        end
    end

endmodule