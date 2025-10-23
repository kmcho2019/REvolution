module TopModule(
    input  [7:0] in,
    output reg [2:0] pos
);

// Generate one-hot masks for each bit
wire [7:0] one_hot;
assign one_hot = in & (~(in - 1'b1)); // isolates the least significant set bit

// Encode the position of the one-hot bit using a balanced logic tree
always @(*) begin
    if (one_hot == 8'b00000000) begin
        pos = 3'd0; // no bits set
    end else if (one_hot[7]) begin
        pos = 3'd7;
    end else if (one_hot[6]) begin
        pos = 3'd6;
    end else if (one_hot[5]) begin
        pos = 3'd5;
    end else if (one_hot[4]) begin
        pos = 3'd4;
    end else if (one_hot[3]) begin
        pos = 3'd3;
    end else if (one_hot[2]) begin
        pos = 3'd2;
    end else if (one_hot[1]) begin
        pos = 3'd1;
    end else begin
        pos = 3'd0;
    end
end

endmodule