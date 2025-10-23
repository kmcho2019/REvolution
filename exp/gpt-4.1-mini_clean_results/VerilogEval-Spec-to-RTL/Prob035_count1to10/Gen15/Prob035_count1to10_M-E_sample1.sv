module TopModule (
    input         clk,
    input         reset,
    output reg [3:0] q
);

    reg [9:0] one_hot;

    // Synchronous one-hot shift register counter
    always @(posedge clk) begin
        if (reset) begin
            one_hot <= 10'b0000000001;  // count = 1
        end else begin
            // Circular rotate left by 1: if MSB=1, wrap around to LSB
            one_hot <= {one_hot[8:0], one_hot[9]};
        end
    end

    // Decode one-hot count to binary (1 to 10)
    always @(*) begin
        case (one_hot)
            10'b0000000001: q = 4'd1;
            10'b0000000010: q = 4'd2;
            10'b0000000100: q = 4'd3;
            10'b0000001000: q = 4'd4;
            10'b0000010000: q = 4'd5;
            10'b0000100000: q = 4'd6;
            10'b0001000000: q = 4'd7;
            10'b0010000000: q = 4'd8;
            10'b0100000000: q = 4'd9;
            10'b1000000000: q = 4'd10;
            default:       q = 4'd1;  // safe default to 1
        endcase
    end

endmodule