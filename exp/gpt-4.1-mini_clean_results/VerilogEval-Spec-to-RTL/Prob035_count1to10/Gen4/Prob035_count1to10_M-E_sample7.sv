module TopModule(
    input clk,
    input reset,
    output reg [3:0] q
);

    reg [9:0] one_hot;

    // Shift the hot bit, wrap from bit 9 to bit 0
    always @(posedge clk) begin
        if (reset) begin
            one_hot <= 10'b0000000001; // count = 1
        end else begin
            one_hot <= {one_hot[8:0], one_hot[9]};
        end
    end

    // Encode the one_hot to binary 1-10
    always @(*) begin
        case(one_hot)
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
            default:       q = 4'd1; // safe default
        endcase
    end

endmodule