module TopModule (
    input        clk,
    input        aresetn,  // asynchronous active-low reset
    input        x,
    output reg   z
);

    // State encoding (2 bits)
    localparam [1:0]
        IDLE  = 2'b00,
        S1    = 2'b01,  // matched "1"
        S10   = 2'b10;  // matched "10"

    reg [1:0] state, next_state;

    // Next state logic
    always @(*) begin
        case (state)
            IDLE:   next_state = (x) ? S1 : IDLE;
            S1:     next_state = (x) ? S1 : S10;
            S10:    next_state = (x) ? S1 : IDLE;
            default:next_state = IDLE;
        endcase
    end

    // Output logic (Mealy): z = 1 when sequence "101" detected
    // This occurs on input x=1 while in state S10 (matched "10" before)
    always @(*) begin
        z = (state == S10) && x;
    end

    // State register with asynchronous negative-edge reset
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            state <= IDLE;
        else
            state <= next_state;
    end

endmodule