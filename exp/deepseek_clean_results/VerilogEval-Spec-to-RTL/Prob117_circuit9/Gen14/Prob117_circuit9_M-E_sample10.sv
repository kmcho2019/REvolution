module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

// Internal shift register storing the sequence: 4,5,6,0,1
reg [14:0] seq_reg = {3'b001, 3'b000, 3'b110, 3'b101, 3'b100};

always @(posedge clk) begin
    if (a) begin
        q <= 3'b100;  // Fixed value when a is high
    end else begin
        // Rotate the sequence register and output current value
        seq_reg <= {seq_reg[11:0], seq_reg[14:12]};
        q <= seq_reg[14:12];
    end
end

endmodule