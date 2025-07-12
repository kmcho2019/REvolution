module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    // State encoding: representing count of consecutive ones (0 to 7)
    typedef enum reg [3:0] {
        S0 = 4'd0, // 0 consecutive ones
        S1 = 4'd1,
        S2 = 4'd2,
        S3 = 4'd3,
        S4 = 4'd4,
        S5 = 4'd5,
        S6 = 4'd6,
        S7 = 4'd7 // 7 or more consecutive ones (error)
    } state_t;

    state_t state, next_state;

    // Next-state logic
    always @(*) begin
        case (state)
            S0: next_state = in ? S1 : S0;
            S1: next_state = in ? S2 : S0;
            S2: next_state = in ? S3 : S0;
            S3: next_state = in ? S4 : S0;
            S4: next_state = in ? S5 : S0;
            S5: next_state = in ? S6 : S0;
            S6: next_state = in ? S7 : S0;
            S7: next_state = in ? S7 : S0; // Remain in error state on continuing ones
            default: next_state = S0;
        endcase
    end

    // Output logic: Moore outputs depend only on current state (registered outputs)
    // Outputs are asserted one cycle after detection (on next clock)
    always @(*) begin
        // Default outputs deasserted
        disc = 1'b0;
        flag = 1'b0;
        err  = 1'b0;

        case (state)
            S5: if (!in) disc = 1'b1;   // 0111110 detected → discard stuffed zero
            S6: if (!in) flag = 1'b1;   // 01111110 detected → flag boundary
            S7: err = 1'b1;             // 7 or more consecutive ones → error
            default: ; // No outputs asserted
        endcase
    end

    // State register and synchronous reset
    always @(posedge clk) begin
        if (reset) 
            state <= S0;
        else
            state <= next_state;
    end

endmodule