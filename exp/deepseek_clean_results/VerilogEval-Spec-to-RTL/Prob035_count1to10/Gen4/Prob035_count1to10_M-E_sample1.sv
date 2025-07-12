module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

reg [9:0] state;  // One-hot state: state[0] = 1, state[1] = 2, ... state[9] = 10

always @(posedge clk) begin
    if (reset) begin
        state <= 10'b0000000001;  // Reset to state 1
    end
    else begin
        if (state[9]) begin      // If in state 10
            state <= 10'b0000000001;  // Wrap to state 1
        end
        else begin
            state <= state << 1;  // Shift to next state
        end
    end
end

// Output encoding: convert one-hot to binary
always @(*) begin
    case (state)
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
        default:        q = 4'd1;
    endcase
end

endmodule