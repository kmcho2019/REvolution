module TopModule(
    input clk,
    input reset,
    input x,
    output reg z
);
    // One-hot encoding for 5 states, only 5 bits used:
    // s0 = 00001, s1 = 00010, s2 = 00100, s3 = 01000, s4 = 10000
    reg [4:0] state, next_state;

    always @(posedge clk) begin
        if (reset) begin
            state <= 5'b00001;  // State 000 represented as s0
            z <= 1'b0;
        end else begin
            state <= next_state;

            // Output based on current state
            case (state)
                5'b01000, // s3 (011)
                5'b10000: // s4 (100)
                    z <= 1'b1;
                default:
                    z <= 1'b0;
            endcase
        end
    end

    // Combinational logic for next state
    always @(*) begin
        case (state)
            5'b00001: next_state = x ? 5'b00010 : 5'b00001; // 000 -> 001 if x=1 else 000
            5'b00010: next_state = x ? 5'b10000 : 5'b00010; // 001 -> 100 if x=1 else 001
            5'b00100: next_state = x ? 5'b00010 : 5'b00100; // 010 -> 001 if x=1 else 010
            5'b01000: next_state = x ? 5'b00100 : 5'b00010; // 011 -> 010 if x=1 else 001
            5'b10000: next_state = x ? 5'b10000 : 5'b01000; // 100 -> 100 if x=1 else 011
            default:  next_state = 5'b00001;                // Default reset to s0
        endcase
    end

endmodule