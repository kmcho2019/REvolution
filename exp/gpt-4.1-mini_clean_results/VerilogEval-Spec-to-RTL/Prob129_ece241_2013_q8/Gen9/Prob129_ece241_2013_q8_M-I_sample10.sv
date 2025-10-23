module TopModule (
    input  clk,
    input  aresetn,
    input  x,
    output reg z
);

    // State encoding using typedef enum for clarity
    typedef enum reg [1:0] {
        S0 = 2'b00, // no bits matched
        S1 = 2'b01, // matched '1'
        S2 = 2'b10  // matched "10"
    } state_t;

    state_t state, next_state;

    // State register with asynchronous negative-edge reset
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            state <= S0;
        else
            state <= next_state;
    end

    // Combined next state and output logic (combinational)
    always @(*) begin
        // Defaults to hold current state and zero output
        next_state = state;
        z = 1'b0;

        case (state)
            S0: begin
                if (x) begin
                    next_state = S1;
                    z = 1'b0;
                end else begin
                    next_state = S0;
                    z = 1'b0;
                end
            end
            S1: begin
                if (~x) begin
                    next_state = S2;
                    z = 1'b0;
                end else begin
                    next_state = S1;
                    z = 1'b0;
                end
            end
            S2: begin
                if (x) begin
                    next_state = S1;
                    z = 1'b1; // output asserted here for "101" detected
                end else begin
                    next_state = S0;
                    z = 1'b0;
                end
            end
            default: begin
                next_state = S0;
                z = 1'b0;
            end
        endcase
    end

endmodule