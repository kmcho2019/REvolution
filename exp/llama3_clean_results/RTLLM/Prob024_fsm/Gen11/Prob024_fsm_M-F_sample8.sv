module fsm(
    input logic IN,
    input logic CLK,
    input logic RST,
    output logic MATCH
);

// Define states
enum logic [2:0] {
    S0 = 3'b000, // Initial state
    S1 = 3'b001, // Seen '1'
    S2 = 3'b010, // Seen '10'
    S3 = 3'b011, // Seen '100'
    S4 = 3'b100  // Seen '1001', waiting for final '1'
} state, next_state;

// Sequential logic for state register
always_ff @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= S0;
        MATCH <= 0;
    end else begin
        state <= next_state;
    end
end

// Combinational logic for next state and output
always_comb begin
    case (state)
        S0: begin
            if (IN) begin
                next_state = S1;
                MATCH = 0;
            end else begin
                next_state = S0;
                MATCH = 0;
            end
        end
        S1: begin
            if (!IN) begin
                next_state = S2;
                MATCH = 0;
            end else begin
                next_state = S1;
                MATCH = 0;
            end
        end
        S2: begin
            if (!IN) begin
                next_state = S3;
                MATCH = 0;
            end else begin
                next_state = S1;
                MATCH = 0;
            end
        end
        S3: begin
            if (IN) begin
                next_state = S4;
                MATCH = 0;
            end else begin
                next_state = S1;
                MATCH = 0;
            end
        end
        S4: begin
            if (IN) begin
                next_state = S0;
                MATCH = 1;
            end else begin
                next_state = S1;
                MATCH = 0;
            end
        end
        default: begin
            next_state = S0;
            MATCH = 0;
        end
    endcase
end

endmodule