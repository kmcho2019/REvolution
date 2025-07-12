module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

    reg [9:0] one_hot;  // One-hot register: only one bit high representing counts 1 to 10

    // Combinational function to convert one_hot position to binary count value (1 to 10)
    // Since one_hot has exactly one '1', use a simple case statement or priority encoding.
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
            default: q = 4'd1; // Safe default, e.g. after reset or fault
        endcase
    end

    always @(posedge clk) begin
        if (reset) begin
            one_hot <= 10'b0000000001;  // Count = 1 on reset
        end else begin
            // Shift the '1' to the left, wrap around after the 10th bit
            if (one_hot[9])
                one_hot <= 10'b0000000001;
            else
                one_hot <= one_hot << 1;
        end
    end

endmodule