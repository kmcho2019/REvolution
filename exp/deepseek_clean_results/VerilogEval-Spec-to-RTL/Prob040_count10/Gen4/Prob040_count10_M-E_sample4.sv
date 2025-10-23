module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

// One-hot encoded state machine for decade counter
reg [9:0] state;

always @(posedge clk) begin
    if (reset) begin
        state <= 10'b0000000001;  // State 0 (LSB)
        q <= 0;
    end
    else begin
        case (state)
            10'b0000000001: begin  // State 0
                state <= 10'b0000000010;
                q <= 1;
            end
            10'b0000000010: begin  // State 1
                state <= 10'b0000000100;
                q <= 2;
            end
            10'b0000000100: begin  // State 2
                state <= 10'b0000001000;
                q <= 3;
            end
            10'b0000001000: begin  // State 3
                state <= 10'b0000010000;
                q <= 4;
            end
            10'b0000010000: begin  // State 4
                state <= 10'b0000100000;
                q <= 5;
            end
            10'b0000100000: begin  // State 5
                state <= 10'b0001000000;
                q <= 6;
            end
            10'b0001000000: begin  // State 6
                state <= 10'b0010000000;
                q <= 7;
            end
            10'b0010000000: begin  // State 7
                state <= 10'b0100000000;
                q <= 8;
            end
            10'b0100000000: begin  // State 8
                state <= 10'b1000000000;
                q <= 9;
            end
            10'b1000000000: begin  // State 9
                state <= 10'b0000000001;
                q <= 0;
            end
            default: begin        // Fault recovery
                state <= 10'b0000000001;
                q <= 0;
            end
        endcase
    end
end

endmodule