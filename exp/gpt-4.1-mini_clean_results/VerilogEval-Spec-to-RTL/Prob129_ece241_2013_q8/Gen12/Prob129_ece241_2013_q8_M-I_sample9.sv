module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output reg z
);

    // State encoding for synthesis-friendly FSM
    localparam S_IDLE = 2'd0; // no bits matched yet
    localparam S_1    = 2'd1; // matched '1'
    localparam S_10   = 2'd2; // matched "10"

    reg [1:0] state, next_state;

    // Next state logic using case statement for clarity and synthesis optimization
    always @(*) begin
        next_state = state; // default assignment

        case (state)
            S_IDLE: begin
                if (x)
                    next_state = S_1;
                else
                    next_state = S_IDLE;
            end
            S_1: begin
                if (x)
                    next_state = S_1;
                else
                    next_state = S_10;
            end
            S_10: begin
                if (x)
                    next_state = S_1;
                else
                    next_state = S_IDLE;
            end
            default: next_state = S_IDLE; // safe default
        endcase
    end

    // Combinational output logic (Mealy output)
    always @(*) begin
        z = (state == S_10) && (x == 1'b1);
    end

    // State register with asynchronous negative-edge reset
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            state <= S_IDLE;
        else
            state <= next_state;
    end

endmodule