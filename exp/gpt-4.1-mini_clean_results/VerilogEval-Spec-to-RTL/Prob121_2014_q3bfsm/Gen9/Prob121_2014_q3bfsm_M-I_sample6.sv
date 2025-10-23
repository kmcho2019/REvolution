module TopModule(
    input clk,
    input reset,
    input x,
    output reg z
);

    // One-hot encoding for 5 states (5 bits)
    // States:
    // S0 (000) = 5'b00001
    // S1 (001) = 5'b00010
    // S2 (010) = 5'b00100
    // S3 (011) = 5'b01000
    // S4 (100) = 5'b10000

    reg [4:0] state, next_state;

    // Next state logic - combinational
    always @(*) begin
        // default no change
        next_state = 5'b00000;

        case (1'b1)
            state[0]: // S0: 000
                next_state = (x == 1'b0) ? 5'b00001 : 5'b00010;
            state[1]: // S1: 001
                next_state = (x == 1'b0) ? 5'b00010 : 5'b10000;
            state[2]: // S2: 010
                next_state = (x == 1'b0) ? 5'b00100 : 5'b00010;
            state[3]: // S3: 011
                next_state = (x == 1'b0) ? 5'b00010 : 5'b00100;
            state[4]: // S4: 100
                next_state = (x == 1'b0) ? 5'b01000 : 5'b10000;
            default:
                next_state = 5'b00001; // Reset state as default (S0)
        endcase
    end

    // State update on posedge clk with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= 5'b00001; // S0
        else
            state <= next_state;
    end

    // Registered output logic to reduce glitches and switching power
    always @(posedge clk) begin
        case (1'b1)
            state[0]: z <= 1'b0; // S0
            state[1]: z <= 1'b0; // S1
            state[2]: z <= 1'b0; // S2
            state[3]: z <= 1'b1; // S3
            state[4]: z <= 1'b1; // S4
            default:  z <= 1'b0;
        endcase
    end

endmodule