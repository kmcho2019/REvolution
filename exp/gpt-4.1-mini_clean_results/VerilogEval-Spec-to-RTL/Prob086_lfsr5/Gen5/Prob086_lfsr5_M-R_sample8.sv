module TopModule (
    input clk,
    input reset,
    output reg [4:0] q
);

// Compute next state combinationally
wire next_bit4 = q[0];
wire next_bit3 = q[4];
wire next_bit2 = q[3] ^ q[0];
wire next_bit1 = q[2];
wire next_bit0 = q[1];

wire [4:0] next_q = {next_bit4, next_bit3, next_bit2, next_bit1, next_bit0};

always @(posedge clk) begin
    if (reset) begin
        q <= 5'b00001;
    end else begin
        q <= next_q;
    end
end

endmodule