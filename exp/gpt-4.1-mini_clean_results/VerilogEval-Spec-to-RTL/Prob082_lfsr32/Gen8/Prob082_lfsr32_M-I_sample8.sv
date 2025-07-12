module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    wire feedback = q[0];
    wire next_bit_31 = q[31] ^ feedback; // tap at bit 32
    wire next_bit_21 = q[21] ^ feedback; // tap at bit 22
    wire next_bit_1  = q[1]  ^ feedback; // tap at bit 2
    wire next_bit_0  = q[0]  ^ feedback; // tap at bit 1

    always @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            q[31] <= next_bit_31;
            q[30:22] <= q[31:23];
            q[21] <= next_bit_21;
            q[20:2] <= q[21:3];
            q[1] <= next_bit_1;
            q[0] <= next_bit_0;
        end
    end

endmodule