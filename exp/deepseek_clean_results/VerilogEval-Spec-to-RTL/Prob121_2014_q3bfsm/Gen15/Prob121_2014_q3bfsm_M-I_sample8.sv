module TopModule (
    input clk,
    input reset,
    input x,
    output reg z
);

    // One-hot state encoding
    reg [4:0] state;  // bits: [4]100, [3]011, [2]010, [1]001, [0]000
    
    // Clock gating signal
    wire clk_en = ~(state[0] & ~x) | reset;
    wire gated_clk = clk & clk_en;

    always @(posedge gated_clk) begin
        if (reset) begin
            state <= 5'b00001;  // Reset to state 000
            z <= 0;
        end
        else begin
            case (1'b1)  // One-hot case statement
                state[0]: begin // 000
                    state <= x ? 5'b00010 : 5'b00001;
                    z <= 0;
                end
                state[1]: begin // 001
                    state <= x ? 5'b10000 : 5'b00010;
                    z <= 0;
                end
                state[2]: begin // 010
                    state <= x ? 5'b00010 : 5'b00100;
                    z <= 0;
                end
                state[3]: begin // 011
                    state <= x ? 5'b00100 : 5'b00010;
                    z <= 1;
                end
                state[4]: begin // 100
                    state <= x ? 5'b10000 : 5'b01000;
                    z <= 1;
                end
                default: begin  // Should never occur
                    state <= 5'b00001;
                    z <= 0;
                end
            endcase
        end
    end

endmodule