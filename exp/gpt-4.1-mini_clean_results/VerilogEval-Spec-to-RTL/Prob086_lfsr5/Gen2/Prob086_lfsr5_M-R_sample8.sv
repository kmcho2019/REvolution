module TopModule(
    input clk,
    input reset,
    output reg [4:0] q
);

wire feedback = q[0];

// Next state logic using continuous assignments for combinational logic
wire next_bit0 = q[1];
wire next_bit1 = q[2];
wire next_bit2 = q[3] ^ feedback; // tap at bit 3 (q[2])
wire next_bit3 = q[4];
wire next_bit4 = feedback;        // tap at bit 5 (q[4])

always @(posedge clk) begin
    if (reset) begin
        q <= 5'b00001;
    end else begin
        q <= {next_bit4, next_bit3, next_bit2, next_bit1, next_bit0};
    end
end

endmodule