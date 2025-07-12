module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

    reg [9:0] ring;

    // Decode the one-hot ring position to a 4-bit binary count
    always @(*) begin
        case (ring)
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
            default:       q = 4'd0; // Safety default
        endcase
    end

    always @(posedge clk) begin
        if (reset) begin
            ring <= 10'b0000000001; // Initialize count 0
        end else begin
            // Rotate left by one position
            ring <= {ring[8:0], ring[9]};
        end
    end

endmodule