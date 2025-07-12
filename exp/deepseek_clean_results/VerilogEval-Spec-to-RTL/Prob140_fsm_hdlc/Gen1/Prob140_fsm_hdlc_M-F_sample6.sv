module TopModule (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    // Define states as parameters
    parameter S0 = 3'd0;  // Initial state or after 0
    parameter S1 = 3'd1;  // 1
    parameter S2 = 3'd2;  // 11
    parameter S3 = 3'd3;  // 111
    parameter S4 = 3'd4;  // 1111
    parameter S5 = 3'd5;  // 11111
    parameter S6 = 3'd6;  // 111111 (flag)
    parameter S7 = 3'd7;  // 1111111+ (error)

    // State registers
    reg [2:0] current_state, next_state;

    // State transition logic
    always @(*) begin
        case (current_state)
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

    // Output logic (Moore style - depends only on current state)
    always @(*) begin
        disc = 0;
        flag = 0;
        err = 0;

        case (current_state)
            S5: disc = in;  // After 5 1s, if next is 1, discard
            S6: flag = ~in; // After 6 1s, if next is 0, flag
            S7: err = 1;     // 7 or more 1s is error
            default: begin
                disc = 0;
                flag = 0;
                err = 0;
            end
        endcase
    end

    // State update
    always @(posedge clk) begin
        if (reset) begin
            current_state <= S0;
        end else begin
            current_state <= next_state;
        end
    end

endmodule