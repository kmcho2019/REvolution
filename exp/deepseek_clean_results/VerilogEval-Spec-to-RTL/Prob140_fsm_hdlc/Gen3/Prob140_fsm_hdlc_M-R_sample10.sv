module TopModule (
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

    // One-hot encoded states
    localparam [7:0] 
        IDLE = 8'b00000001,
        S1   = 8'b00000010,
        S2   = 8'b00000100,
        S3   = 8'b00001000,
        S4   = 8'b00010000,
        S5   = 8'b00100000,
        S6   = 8'b01000000,
        ERR  = 8'b10000000;

    reg [7:0] state, next_state;

    // State transition logic
    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: next_state = in ? S1 : IDLE;
            S1:   next_state = in ? S2 : IDLE;
            S2:   next_state = in ? S3 : IDLE;
            S3:   next_state = in ? S4 : IDLE;
            S4:   next_state = in ? S5 : IDLE;
            S5:   next_state = in ? S6 : IDLE;
            S6:   next_state = in ? ERR : IDLE;
            ERR:  next_state = in ? ERR : IDLE;
            default: next_state = IDLE;
        endcase
    end

    // Output logic (combinational)
    assign disc = (state == S5) && !in;
    assign flag = (state == S6) && !in;
    assign err  = (state == ERR);

endmodule