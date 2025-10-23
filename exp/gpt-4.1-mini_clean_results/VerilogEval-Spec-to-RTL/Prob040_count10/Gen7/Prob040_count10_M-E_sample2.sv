module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

    reg [9:0] one_hot;

    // On reset, set one_hot to 0000000001 (count=0)
    // On each clock, rotate the '1' bit left by 1, wrapping around
    always @(posedge clk) begin
        if (reset)
            one_hot <= 10'b0000000001;
        else begin
            // If the highest bit is set, wrap to bit 0
            if (one_hot[9])
                one_hot <= 10'b0000000001;
            else
                one_hot <= one_hot << 1;
        end
    end

    // Decode one_hot to binary count q
    always @(*) begin
        case (one_hot)
            10'b0000000001: q = 4'd0;
            10'b0000000010: q = 4'd1;
            10'b0000000100: q = 4'd2;
            10'b0000001000: q = 4'd3;
            10'b0000010000: q = 4'd4;
            10'b0000100000: q = 4'd5;
            10'b0001000000: q = 4'd6;
            10'b0010000000: q = 4'd7;
            10'b0100000000: q = 4'd8;
            10'b1000000000: q = 4'd9;
            default:        q = 4'd0; // safe default on invalid states
        endcase
    end

endmodule