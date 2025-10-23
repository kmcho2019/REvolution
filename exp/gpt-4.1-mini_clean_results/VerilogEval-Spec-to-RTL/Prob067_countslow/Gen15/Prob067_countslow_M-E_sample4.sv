module TopModule (
    input clk,
    input reset,
    input slowena,
    output reg [3:0] q
);

    reg [9:0] onehot;

    // Synchronous reset and shift enable logic
    always @(posedge clk) begin
        if (reset) begin
            onehot <= 10'b0000000001;  // count = 0
        end else if (slowena) begin
            if (onehot == 10'b1000000000)
                onehot <= 10'b0000000001;  // wrap from 9 to 0
            else
                onehot <= onehot << 1;      // shift '1' to the left by 1
        end
        // else hold current state
    end

    // Decode onehot to binary count
    always @(*) begin
        casez(onehot)
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
            default:        q = 4'd0; // fallback for safety
        endcase
    end

endmodule