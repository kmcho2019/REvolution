module fsm(
    input  logic IN,
    input  logic CLK,
    input  logic RST,
    output logic MATCH
);

// Define states
typedef enum logic [2:0] {
    S0,  // Initial state
    S1,  // First '1' detected
    S2,  // '0' detected after the first '1'
    S3,  // Second '0' detected
    S4,  // '1' detected after two '0's
    S5   // Final '1' detected, match found
} state_type;

// Current and next state
state_type current_state, next_state;

// Initialize output
assign MATCH = (current_state == S5) ? 1'b1 : 1'b0;

// Sequential logic
always_ff @(posedge CLK or posedge RST) begin
    if (RST) begin
        current_state <= S0;
    end else begin
        current_state <= next_state;
    end
end

// Combinational logic
always_comb begin
    case (current_state)
        S0: begin
            if (IN) begin
                next_state = S1;
            end else begin
                next_state = S0;
            end
        end
        S1: begin
            if (!IN) begin
                next_state = S2;
            end else begin
                next_state = S1;
            end
        end
        S2: begin
            if (!IN) begin
                next_state = S3;
            end else begin
                next_state = S1;
            end
        end
        S3: begin
            if (IN) begin
                next_state = S4;
            end else begin
                next_state = S0;
            end
        end
        S4: begin
            if (IN) begin
                next_state = S5;
            end else begin
                next_state = S0;
            end
        end
        S5: begin
            if (IN) begin
                next_state = S1;
            end else begin
                next_state = S0;
            end
        end
        default: next_state = S0;
    endcase
end

endmodule