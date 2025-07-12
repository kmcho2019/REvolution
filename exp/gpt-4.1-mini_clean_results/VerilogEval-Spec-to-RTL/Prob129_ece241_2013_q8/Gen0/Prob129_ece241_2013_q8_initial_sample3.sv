module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output reg z
);

    // State encoding
    typedef enum logic [1:0] {
        S0 = 2'b00, // no bits matched
        S1 = 2'b01, // matched '1'
        S2 = 2'b10  // matched '10'
    } state_t;

    state_t state, next_state;

    // Next state and output logic (Mealy machine)
    always @(*) begin
        z = 1'b0;
        case (state)
            S0: begin
                if (x)
                    next_state = S1;
                else
                    next_state = S0;
            end
            S1: begin
                if (x)
                    next_state = S1; // matched another '1', stay in S1
                else
                    next_state = S2; // matched '10'
            end
            S2: begin
                if (x) begin
                    next_state = S1; // matched '101', overlapping => go to S1
                    z = 1'b1;         // output asserted on detecting '101'
                end else
                    next_state = S0;
            end
            default: begin
                next_state = S0;
            end
        endcase
    end

    // Sequential logic: state register with negative edge asynchronous reset
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            state <= S0;
        else
            state <= next_state;
    end

endmodule