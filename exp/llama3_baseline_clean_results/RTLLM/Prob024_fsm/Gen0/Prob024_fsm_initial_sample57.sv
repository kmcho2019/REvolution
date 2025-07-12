module fsm(
    input  logic IN,    // Input signal to the FSM
    input  logic CLK,   // Clock signal used for synchronous operation
    input  logic RST,   // Reset signal to initialize the FSM
    output logic MATCH  // Output signal indicating a match condition based on the FSM state
);

// Define the states for the FSM
parameter S0 = 4'd0, S1 = 4'd1, S2 = 4'd2, S3 = 4'd3, S4 = 4'd4, S5 = 4'd5;

// Current state and next state variables
logic [3:0] current_state, next_state;

// Define the sequence to match
parameter SEQUENCE = 5'b10011;

// Output logic for MATCH
assign MATCH = (current_state == S5)? 1'b1 : 1'b0;

// Combinational logic for next state
always_comb begin
    case (current_state)
        S0: begin
            if (IN == 1'b1)
                next_state = S1;
            else
                next_state = S0;
        end
        S1: begin
            if (IN == 1'b0)
                next_state = S2;
            else
                next_state = S0;
        end
        S2: begin
            if (IN == 1'b0)
                next_state = S3;
            else
                next_state = S0;
        end
        S3: begin
            if (IN == 1'b1)
                next_state = S4;
            else
                next_state = S0;
        end
        S4: begin
            if (IN == 1'b1)
                next_state = S5;
            else
                next_state = S0;
        end
        S5: begin
            next_state = S0; // Reset to S0 after match
        end
        default: next_state = S0;
    endcase
end

// Sequential logic for current state
always_ff @(posedge CLK or posedge RST) begin
    if (RST) begin
        current_state <= S0;
    end else begin
        current_state <= next_state;
    end
end

endmodule