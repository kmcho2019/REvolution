module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

    reg [9:0] one_hot_count;  // one-hot encoded count for 1 to 10

    // One-hot encoding states:
    // bit 0 => count 1
    // bit 1 => count 2
    // ...
    // bit 9 => count 10

    always @(posedge clk) begin
        if (reset) begin
            one_hot_count <= 10'b0000000001; // count = 1
        end else begin
            // shift left by 1, wrap around after count 10
            if (one_hot_count == 10'b1000000000)
                one_hot_count <= 10'b0000000001;
            else
                one_hot_count <= one_hot_count << 1;
        end
    end

    always @(*) begin
        case (one_hot_count)
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
            default:        q = 4'd0;  // default shouldn't occur
        endcase
    end

endmodule