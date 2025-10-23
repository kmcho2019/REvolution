module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    // State encoding: S0 to S6 track consecutive ones count; S7 is error state (7 or more ones)
    typedef enum reg [3:0] {
        S0 = 4'd0,  // no consecutive ones
        S1 = 4'd1,
        S2 = 4'd2,
        S3 = 4'd3,
        S4 = 4'd4,
        S5 = 4'd5,
        S6 = 4'd6,
        S7 = 4'd7   // error state: 7+ consecutive ones
    } state_t;

    reg [3:0] current_state, next_state;

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

    // Sequential state update and output assignment (Moore FSM)
    always @(posedge clk) begin
        if (reset) begin
            current_state <= S0;
            disc  <= 1'b0;
            flag  <= 1'b0;
            err   <= 1'b0;
        end else begin
            current_state <= next_state;

            // Default outputs
            disc <= 1'b0;
            flag <= 1'b0;
            err  <= 1'b0;

            // Outputs depend only on current_state (Moore outputs asserted for one cycle)
            case (current_state)
                S5: if (in == 1'b0) disc <= 1'b1;    // 5 ones then zero => discard zero bit
                S6: if (in == 1'b0) flag <= 1'b1;    // 6 ones then zero => flag
                S7: err <= 1'b1;                     // 7 or more ones => error
                default: begin end
            endcase
        end
    end

endmodule