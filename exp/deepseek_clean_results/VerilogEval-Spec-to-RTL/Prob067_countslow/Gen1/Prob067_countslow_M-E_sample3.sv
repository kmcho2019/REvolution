module TopModule (
    input clk,
    input reset,
    input slowena,
    output reg [3:0] q
);

reg [9:0] onehot_cnt;  // One-hot representation (bit 0 = 0, bit 9 = 9)

always @(posedge clk) begin
    if (reset) begin
        onehot_cnt <= 10'b0000000001;  // Reset to 0 (one-hot)
    end
    else if (slowena) begin
        if (onehot_cnt[9]) begin       // If at count 9
            onehot_cnt <= 10'b0000000001; // Wrap to 0
        end
        else begin
            onehot_cnt <= {onehot_cnt[8:0], 1'b0}; // Shift left
        end
    end
end

// Convert one-hot to binary output
always @(*) begin
    case (onehot_cnt)
        10'b0000000001: q = 4'b0000;
        10'b0000000010: q = 4'b0001;
        10'b0000000100: q = 4'b0010;
        10'b0000001000: q = 4'b0011;
        10'b0000010000: q = 4'b0100;
        10'b0000100000: q = 4'b0101;
        10'b0001000000: q = 4'b0110;
        10'b0010000000: q = 4'b0111;
        10'b0100000000: q = 4'b1000;
        10'b1000000000: q = 4'b1001;
        default:        q = 4'b0000;
    endcase
end

endmodule