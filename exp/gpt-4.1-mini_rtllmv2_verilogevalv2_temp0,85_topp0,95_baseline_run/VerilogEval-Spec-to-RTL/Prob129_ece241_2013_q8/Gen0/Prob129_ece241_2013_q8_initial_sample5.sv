module TopModule (
    input  clk,
    input  aresetn, // async negative edge reset
    input  x,
    output reg z
);

    typedef enum logic [1:0] {
        S0 = 2'b00,
        S1 = 2'b01,
        S2 = 2'b10
    } state_t;

    state_t state, next_state;

    // Asynchronous negative edge reset with positive clock edge FSM
    always_ff @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            state <= S0;
        else
            state <= next_state;
    end

    always_comb begin
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
                    next_state = S1;
                else
                    next_state = S2;
            end
            S2: begin
                if (x) begin
                    next_state = S1;
                    z = 1'b1; // sequence "101" detected here
                end else
                    next_state = S0;
            end
            default: begin
                next_state = S0;
                z = 1'b0;
            end
        endcase
    end

endmodule