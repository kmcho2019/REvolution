module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    // Define states corresponding to counts of consecutive ones (0 to 7+)
    typedef enum reg [3:0] {
        S0 = 4'd0,  // 0 consecutive ones
        S1 = 4'd1,  // 1 consecutive one
        S2 = 4'd2,  // 2 consecutive ones
        S3 = 4'd3,  // 3 consecutive ones
        S4 = 4'd4,  // 4 consecutive ones
        S5 = 4'd5,  // 5 consecutive ones
        S6 = 4'd6,  // 6 consecutive ones
        S7 = 4'd7   // 7 or more consecutive ones (error state)
    } state_t;

    state_t current_state, next_state;

    // Next state logic
    always @(*) begin
        case (current_state)
            S0: next_state = in ? S1 : S0;
            S1: next_state = in ? S2 : S0;
            S2: next_state = in ? S3 : S0;
            S3: next_state = in ? S4 : S0;
            S4: next_state = in ? S5 : S0;
            S5: next_state = in ? S6 : S0;
            S6: next_state = in ? S7 : S0;
            S7: next_state = in ? S7 : S0; // Remain in error state if more ones; else reset
            default: next_state = S0;
        endcase
    end

    // State register update
    always @(posedge clk) begin
        if (reset) begin
            current_state <= S0;
        end else begin
            current_state <= next_state;
        end
    end

    // Output logic: outputs asserted one cycle after detection, Moore type
    always @(posedge clk) begin
        if (reset) begin
            disc <= 1'b0;
            flag <= 1'b0;
            err  <= 1'b0;
        end else begin
            // disc = detected 5 consecutive ones then a zero input (0 after 5 ones)
            disc <= (current_state == S5) && (in == 1'b0);
            // flag = detected 6 consecutive ones then a zero input (flag pattern)
            flag <= (current_state == S6) && (in == 1'b0);
            // err = detected 7 or more consecutive ones (error)
            err  <= (current_state == S7);
        end
    end

endmodule