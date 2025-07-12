module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output reg z
);

    // State encoding using localparams for clarity
    localparam S_IDLE = 2'd0; // waiting for '1'
    localparam S_1    = 2'd1; // matched '1'
    localparam S_10   = 2'd2; // matched "10"

    reg [1:0] state, next_state;

    // State register with async negedge reset
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            state <= S_IDLE;
        else
            state <= next_state;
    end

    // Next state and output logic (Mealy FSM)
    always @(*) begin
        z = 1'b0;
        case(state)
            S_IDLE: begin
                if (x)
                    next_state = S_1;
                else
                    next_state = S_IDLE;
            end

            S_1: begin
                if (!x)
                    next_state = S_10;
                else
                    next_state = S_1; // Stay since repeated '1's could start new sequence
            end

            S_10: begin
                if (x) begin
                    next_state = S_1; // Overlapping: last '1' can be start of next sequence
                    z = 1'b1;         // Sequence "101" detected here
                end else
                    next_state = S_IDLE;
            end

            default: begin
                next_state = S_IDLE;
                z = 1'b0;
            end
        endcase
    end

endmodule