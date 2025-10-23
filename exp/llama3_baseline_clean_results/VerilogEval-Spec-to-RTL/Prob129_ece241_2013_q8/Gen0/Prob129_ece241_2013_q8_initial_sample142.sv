module TopModule (
    input clk,
    input aresetn,
    input x,
    output z
);

    // Define the states
    enum logic [1:0] {IDLE, S1, S2} state, next_state;

    // Asynchronous reset
    always @(posedge clk or negedge aresetn) begin
        if (~aresetn) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (x) begin
                    next_state = S1;
                end else begin
                    next_state = IDLE;
                end
            end
            S1: begin
                if (~x) begin
                    next_state = S2;
                end else begin
                    next_state = S1;
                end
            end
            S2: begin
                if (x) begin
                    next_state = S1; // Transition to S1 to recognize overlapping sequences
                end else begin
                    next_state = IDLE;
                end
            end
        endcase
    end

    // Output logic
    always @(*) begin
        case (state)
            IDLE: z = 1'b0;
            S1: z = 1'b0;
            S2: z = x; // Assert z to 1 when the sequence "101" is detected
        endcase
    end

endmodule