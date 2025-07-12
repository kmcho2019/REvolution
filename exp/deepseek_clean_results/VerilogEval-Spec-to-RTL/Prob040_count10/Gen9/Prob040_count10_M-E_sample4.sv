module TopModule (
    input clk,
    input reset,
    output [3:0] q
);

reg [9:0] one_hot;

// One-hot circular shift register
always @(posedge clk) begin
    if (reset) begin
        one_hot <= 10'b0000000001;
    end
    else begin
        case (one_hot)
            10'b0000000001: one_hot <= 10'b0000000010;
            10'b0000000010: one_hot <= 10'b0000000100;
            10'b0000000100: one_hot <= 10'b0000001000;
            10'b0000001000: one_hot <= 10'b0000010000;
            10'b0000010000: one_hot <= 10'b0000100000;
            10'b0000100000: one_hot <= 10'b0001000000;
            10'b0001000000: one_hot <= 10'b0010000000;
            10'b0010000000: one_hot <= 10'b0100000000;
            10'b0100000000: one_hot <= 10'b1000000000;
            10'b1000000000: one_hot <= 10'b0000000001;
            default: one_hot <= 10'b0000000001;
        endcase
    end
end

// One-hot to binary encoder
assign q = (one_hot[0]) ? 4'b0000 :
           (one_hot[1]) ? 4'b0001 :
           (one_hot[2]) ? 4'b0010 :
           (one_hot[3]) ? 4'b0011 :
           (one_hot[4]) ? 4'b0100 :
           (one_hot[5]) ? 4'b0101 :
           (one_hot[6]) ? 4'b0110 :
           (one_hot[7]) ? 4'b0111 :
           (one_hot[8]) ? 4'b1000 :
           (one_hot[9]) ? 4'b1001 :
           4'b0000;

endmodule