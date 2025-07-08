module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

    // State encoding for sequence detection: looking for 1101
    typedef enum reg [2:0] {
        S0 = 3'b000, // no bits matched
        S1 = 3'b001, // matched 1
        S11 = 3'b010, // matched 11
        S110 = 3'b011, // matched 110
        S_FOUND = 3'b100 // matched 1101, found sequence
    } state_t;

    reg [2:0] current_state, next_state;

    // Next state logic for sequence detection
    always @(*) begin
        case(current_state)
            S0: 
                next_state = (data == 1'b1) ? S1 : S0;
            S1:
                next_state = (data == 1'b1) ? S11 : S0;
            S11:
                next_state = (data == 1'b0) ? S110 : S11;
            S110:
                next_state = (data == 1'b1) ? S_FOUND : S0;
            S_FOUND:
                next_state = S_FOUND; // stay here once found
            default:
                next_state = S0;
        endcase
    end

    // State and output update on clock edge, synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            current_state <= S0;
            start_shifting <= 1'b0;
        end else begin
            current_state <= next_state;
            if (current_state == S_FOUND)
                start_shifting <= 1'b1; // latch start_shifting once found
        end
    end

endmodule