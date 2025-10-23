module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    // Define states representing counts of consecutive ones
    typedef enum reg [3:0] {
        S0  = 4'd0,  // no consecutive ones
        S1  = 4'd1,
        S2  = 4'd2,
        S3  = 4'd3,
        S4  = 4'd4,
        S5  = 4'd5,
        S6  = 4'd6,
        S7p = 4'd7   // 7 or more ones (error state)
    } state_t;

    reg [3:0] state, next_state;

    // State transition combinational logic
    always @(*) begin
        case (state)
            S0:  next_state = in ? S1 : S0;
            S1:  next_state = in ? S2 : S0;
            S2:  next_state = in ? S3 : S0;
            S3:  next_state = in ? S4 : S0;
            S4:  next_state = in ? S5 : S0;
            S5:  next_state = in ? S6 : S0;
            S6:  next_state = in ? S7p : S0;
            S7p: next_state = in ? S7p : S0;
            default: next_state = S0;
        endcase
    end

    // Output logic - Moore outputs depend only on current state
    always @(*) begin
        disc = 1'b0;
        flag = 1'b0;
        err  = 1'b0;
        // Outputs asserted one cycle after detection, so assert for current state conditions
        case (state)
            S5: if (!in) disc = 1'b1;        // detected a zero after 5 ones -> discard bit
            S6: if (!in) flag = 1'b1;        // detected a zero after 6 ones -> flag
            S7p: if (in)  err  = 1'b1;       // 7 or more ones -> error
        endcase
    end

    // Sequential state update with synchronous active-high reset
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
        end else begin
            state <= next_state;
        end
    end

endmodule