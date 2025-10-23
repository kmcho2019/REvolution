module TopModule(
    input  wire clk,
    input  wire reset,
    input  wire in,
    output wire disc,
    output wire flag,
    output wire err
);

    // State encoding:
    // COUNT0 .. COUNT6: consecutive ones count = state index (0..6)
    // DISC_STATE: after 5 consecutive ones + 0 detected
    // FLAG_STATE: after 6 consecutive ones + 0 detected
    // ERR_STATE: 7 or more consecutive ones detected
    typedef enum logic [3:0] {
        COUNT0     = 4'd0,
        COUNT1     = 4'd1,
        COUNT2     = 4'd2,
        COUNT3     = 4'd3,
        COUNT4     = 4'd4,
        COUNT5     = 4'd5,
        COUNT6     = 4'd6,
        DISC_STATE = 4'd7,
        FLAG_STATE = 4'd8,
        ERR_STATE  = 4'd9
    } state_t;

    state_t state, next_state;

    // Next state logic
    always @(*) begin
        case (state)
            COUNT0, COUNT1, COUNT2, COUNT3, COUNT4, COUNT5, COUNT6: begin
                if (in) begin
                    // Input 1: increment count if below 6, else go to error
                    if (state == COUNT6)
                        next_state = ERR_STATE;
                    else
                        next_state = state + 1;
                end else begin
                    // Input 0: check count to generate outputs or reset count
                    case (state)
                        COUNT5: next_state = DISC_STATE;  // disc one cycle after five ones + zero
                        COUNT6: next_state = FLAG_STATE;  // flag one cycle after six ones + zero
                        default: next_state = COUNT0;
                    endcase
                end
            end

            DISC_STATE, FLAG_STATE: begin
                // After output state, next depends on input
                next_state = (in) ? COUNT1 : COUNT0;
            end

            ERR_STATE: begin
                // In error state, stay in error if input 1; else reset
                next_state = (in) ? ERR_STATE : COUNT0;
            end

            default: next_state = COUNT0; // safe default
        endcase
    end

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= COUNT0;
        else
            state <= next_state;
    end

    // Moore outputs: asserted for one cycle in output states
    assign disc = (state == DISC_STATE);
    assign flag = (state == FLAG_STATE);
    assign err  = (state == ERR_STATE);

endmodule