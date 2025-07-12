module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

    reg [9:0] one_hot;

    // Decode one_hot to binary count (1 to 10)
    // Using a simple priority encoding based on one_hot bit position
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
            default:        q = 4'd0; // Should not happen, fallback
        endcase
    end

    always @(posedge clk) begin
        if (reset) begin
            one_hot <= 10'b0000000001; // Count starts at 1
        end else begin
            if (one_hot == 10'b1000000000)
                one_hot <= 10'b0000000001; // Wrap around to 1 after 10
            else
                one_hot <= one_hot << 1; // Shift left to move to next count
        end
    end

endmodule