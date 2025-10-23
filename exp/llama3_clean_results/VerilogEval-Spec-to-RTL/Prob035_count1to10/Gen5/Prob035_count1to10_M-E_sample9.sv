module TopModule(
    input clk,
    input reset,
    output [3:0] q
);

reg [9:0] state; // One-hot encoding for states 1 to 10

always @(posedge clk) begin
    if (reset) begin
        state <= 1; // Reset to state 1
    end else begin
        case (state)
            1: state <= 2;
            2: state <= 4;
            4: state <= 8;
            8: state <= 16; // This represents state 9 (since 2^4 = 16)
            16: state <= 32; // This represents state 10 (since 2^5 = 32)
            32: state <= 1; // Reset back to state 1 after reaching state 10
            default: state <= 1; // Default to state 1 for any other value
        endcase
    end
end

// Convert one-hot encoding to binary output
always @(*) begin
    case (state)
        1: q <= 4'd1;
        2: q <= 4'd2;
        4: q <= 4'd3;
        8: q <= 4'd4;
        16: q <= 4'd5;
        32: q <= 4'd6;
        64: q <= 4'd7;
        128: q <= 4'd8;
        256: q <= 4'd9;
        512: q <= 4'd10;
        default: q <= 4'd1; // Default to 1 for any other value
    endcase
end

endmodule