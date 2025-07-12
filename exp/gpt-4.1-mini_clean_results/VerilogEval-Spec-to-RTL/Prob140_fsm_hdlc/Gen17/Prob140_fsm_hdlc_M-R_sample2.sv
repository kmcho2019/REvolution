module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    // Define FSM states as number of consecutive ones, max 7 (saturated)
    typedef enum reg [3:0] {
        S0 = 4'd0,  // no consecutive 1s
        S1 = 4'd1,
        S2 = 4'd2,
        S3 = 4'd3,
        S4 = 4'd4,
        S5 = 4'd5,
        S6 = 4'd6,
        S7 = 4'd7  // saturate here (error state)
    } state_t;

    state_t state, state_next;

    // FSM state transitions
    always @(*) begin
        case (state)
            S0: state_next = in ? S1 : S0;
            S1: state_next = in ? S2 : S0;
            S2: state_next = in ? S3 : S0;
            S3: state_next = in ? S4 : S0;
            S4: state_next = in ? S5 : S0;
            S5: state_next = in ? S6 : S0;
            S6: state_next = in ? S7 : S0;
            S7: state_next = in ? S7 : S0;
            default: state_next = S0;
        endcase
    end

    // Moore outputs based on current state and input
    wire disc_next  = (state == S5) && (in == 1'b0);
    wire flag_next  = (state == S6) && (in == 1'b0);
    wire err_next   = (state >= S6) && (in == 1'b1);

    // Synchronous state and outputs update
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            disc  <= 1'b0;
            flag  <= 1'b0;
            err   <= 1'b0;
        end else begin
            state <= state_next;
            disc  <= disc_next;
            flag  <= flag_next;
            err   <= err_next;
        end
    end

endmodule