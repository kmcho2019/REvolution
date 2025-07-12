module fsm(
    input  logic IN,      // Input signal to the FSM
    input  logic CLK,     // Clock signal
    input  logic RST,     // Reset signal
    output logic MATCH    // Output signal indicating a match condition
);

// Define the states of the FSM
enum logic [2:0] {S0, S1, S2, S3, S4, S5} state, next_state;

// Sequential logic
always_ff @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= S0;
        MATCH <= 0;
    end else begin
        state <= next_state;
        if (state == S5) begin
            MATCH <= 1;
        end else begin
            MATCH <= 0;
        end
    end
end

// Combinational logic
always_comb begin
    case (state)
        S0: begin
            if (IN) begin
                next_state = S1;
            end else begin
                next_state = S0;
            end
        end
        S1: begin
            if (~IN) begin
                next_state = S2;
            end else begin
                next_state = S1;
            end
        end
        S2: begin
            if (~IN) begin
                next_state = S3;
            end else begin
                next_state = S1;
            end
        end
        S3: begin
            if (IN) begin
                next_state = S4;
            end else begin
                next_state = S1;
            end
        end
        S4: begin
            if (IN) begin
                next_state = S5;
            end else begin
                next_state = S1;
            end
        end
        S5: begin
            next_state = S1;
        end
        default: next_state = S0;
    endcase
end

endmodule