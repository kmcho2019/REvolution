module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire data,
    output reg  start_shifting
);

    // State encoding
    typedef enum reg [2:0] {
        S0 = 3'b000, // no match
        S1 = 3'b001, // matched '1'
        S2 = 3'b010, // matched "11"
        S3 = 3'b011, // matched "110"
        S4 = 3'b100  // matched "1101" -> sequence found
    } state_t;

    state_t state, next_state;

    // Next state logic
    always @(*) begin
        case(state)
            S0: next_state = (data) ? S1 : S0;
            S1: next_state = (data) ? S2 : S0;
            S2: next_state = (data) ? S2 : S3;
            S3: next_state = (data) ? S4 : S0;
            S4: next_state = S4; // stay once detected
            default: next_state = S0;
        endcase
    end

    // Sequential logic: state update and start_shifting output
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            start_shifting <= 1'b0;
        end else begin
            state <= next_state;
            if (state == S4 || start_shifting)
                start_shifting <= 1'b1;
        end
    end

endmodule