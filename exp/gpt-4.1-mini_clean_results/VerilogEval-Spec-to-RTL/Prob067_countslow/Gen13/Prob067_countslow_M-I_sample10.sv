module TopModule (
    input clk,
    input reset,
    input slowena,
    output reg [3:0] q
);

    reg [9:0] onehot;

    // Synchronous one-hot counter with reset and enable
    always @(posedge clk) begin
        if (reset)
            onehot <= 10'b0000000001;
        else if (slowena)
            onehot <= {onehot[8:0], onehot[9]};
    end

    // Decode one-hot to binary count
    always @(*) begin
        case (onehot)
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
            default:       q = 4'd0; // safe default if invalid state
        endcase
    end

endmodule