module TopModule (
    input  clk,
    input  reset,
    output [3:0] q
);

reg [3:0] state = 4'b0001; // Initial state (1)

always @(posedge clk) begin
    if (reset) begin
        state <= 4'b0001; // Reset to state 1
    end else begin
        case (state)
            4'b0001: state <= 4'b0010; // 1 -> 2
            4'b0010: state <= 4'b0100; // 2 -> 3
            4'b0100: state <= 4'b1000; // 3 -> 4
            4'b1000: state <= 4'b0001_0010; // 4 -> 5 (one-hot encoding for 5, utilizing the next bit)
            4'b0001_0010: state <= 4'b0001_0100; // 5 -> 6
            4'b0001_0100: state <= 4'b0001_1000; // 6 -> 7
            4'b0001_1000: state <= 4'b0010_0001; // 7 -> 8
            4'b0010_0001: state <= 4'b0100_0010; // 8 -> 9
            4'b0100_0010: state <= 4'b1000_0100; // 9 -> 10
            4'b1000_0100: state <= 4'b0001; // 10 -> 1
            default: state <= 4'b0001; // Any other state, reset to 1
        endcase
    end
end

// Convert one-hot state encoding to binary for output
always @(*) begin
    case (state)
        4'b0001: q = 4'd1;
        4'b0010: q = 4'd2;
        4'b0100: q = 4'd3;
        4'b1000: q = 4'd4;
        4'b0001_0010: q = 4'd5;
        4'b0001_0100: q = 4'd6;
        4'b0001_1000: q = 4'd7;
        4'b0010_0001: q = 4'd8;
        4'b0100_0010: q = 4'd9;
        4'b1000_0100: q = 4'd10;
        default: q = 4'd1; // Any other state, output 1
    endcase
end

endmodule