module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

    reg [9:0] one_hot; // One-hot state register for counts 1 to 10

    // Decode one-hot to binary count 1..10
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
            default:        q = 4'd1; // safe default in case of invalid state
        endcase
    end

    always @(posedge clk) begin
        if (reset) begin
            one_hot <= 10'b0000000001; // Start at count 1
        end else begin
            if (one_hot[9]) // If at count 10, wrap around to count 1
                one_hot <= 10'b0000000001;
            else
                one_hot <= one_hot << 1;
        end
    end

endmodule