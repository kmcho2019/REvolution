module TopModule (
    input        clk,
    input        reset,
    output reg [3:0] q
);

    reg [9:0] state; // one-hot encoding for states 1 to 10

    // Decode one-hot state to binary count
    always @(*) begin
        case(state)
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
            default:        q = 4'd1; // default to 1 on invalid state
        endcase
    end

    always @(posedge clk) begin
        if (reset) begin
            state <= 10'b0000000001; // Initialize to count 1
        end else begin
            if (state == 10'b1000000000) begin
                state <= 10'b0000000001; // wrap from 10 to 1
            end else begin
                state <= state << 1; // move one-hot bit to the left
            end
        end
    end

endmodule