module TopModule (
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

    // State encoding - represents number of consecutive 1s seen
    reg [2:0] state;
    reg [2:0] next_state;

    // State definitions
    parameter S0 = 3'b000;  // 0 consecutive 1s
    parameter S1 = 3'b001;  // 1 consecutive 1
    parameter S2 = 3'b010;  // 2 consecutive 1s
    parameter S3 = 3'b011;  // 3 consecutive 1s
    parameter S4 = 3'b100;  // 4 consecutive 1s
    parameter S5 = 3'b101;  // 5 consecutive 1s
    parameter S6 = 3'b110;  // 6 consecutive 1s
    parameter S7 = 3'b111;  // 7+ consecutive 1s (error)

    // State transition logic
    always @(*) begin
        case (state)
            S0: next_state = in ? S1 : S0;
            S1: next_state = in ? S2 : S0;
            S2: next_state = in ? S3 : S0;
            S3: next_state = in ? S4 : S0;
            S4: next_state = in ? S5 : S0;
            S5: next_state = in ? S6 : S0;
            S6: next_state = in ? S7 : S0;
            S7: next_state = in ? S7 : S0;
            default: next_state = S0;
        endcase
    end

    // State register
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
        end else begin
            state <= next_state;
        end
    end

    // Output logic (Moore style - outputs depend only on current state)
    assign disc = (state == S5) && (in == 0);  // 5 ones followed by 0
    assign flag = (state == S6) && (in == 0);  // 6 ones followed by 0
    assign err = (state == S7);                // 7 or more ones

endmodule