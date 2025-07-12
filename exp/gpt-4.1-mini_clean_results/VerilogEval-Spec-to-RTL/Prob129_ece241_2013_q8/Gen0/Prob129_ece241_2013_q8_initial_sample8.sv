module TopModule (
    input  clk,
    input  aresetn,  // active low async reset
    input  x,
    output reg z
);

    // State encoding
    typedef enum logic [1:0] {
        S0 = 2'b00, // initial state, no match
        S1 = 2'b01, // matched '1'
        S2 = 2'b10  // matched '10'
    } state_t;

    state_t current_state, next_state;

    // Asynchronous negative edge reset with synchronous state update on posedge clk
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            current_state <= S0;
        else
            current_state <= next_state;
    end

    // Next state and output logic (Mealy FSM)
    always @(*) begin
        // default outputs
        next_state = current_state;
        z = 1'b0;

        case (current_state)
            S0: begin
                if (x == 1'b1) begin
                    next_state = S1;
                    z = 1'b0;
                end else begin
                    next_state = S0;
                    z = 1'b0;
                end
            end
            S1: begin
                if (x == 1'b0) begin
                    next_state = S2;
                    z = 1'b0;
                end else begin
                    next_state = S1;
                    z = 1'b0;
                end
            end
            S2: begin
                if (x == 1'b1) begin
                    next_state = S1; // because last bit is '1', possibly start of new sequence
                    z = 1'b1;        // sequence "101" detected here
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