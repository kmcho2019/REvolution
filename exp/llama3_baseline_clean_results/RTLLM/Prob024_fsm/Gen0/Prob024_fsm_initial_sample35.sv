module fsm (
    input   logic       IN,      // Input signal to the FSM
    input   logic       CLK,     // Clock signal used for synchronous operation
    input   logic       RST,     // Reset signal to initialize the FSM
    output  logic       MATCH    // Output signal indicating a match condition based on the FSM state
);

// Define states
localparam   IDLE    = 4'b0000;
localparam   S1      = 4'b0001;
localparam   S2      = 4'b0010;
localparam   S3      = 4'b0011;
localparam   S4      = 4'b0100;
localparam   S5      = 4'b0101;

// Current and next state
logic [3:0]   curr_state, next_state;

// Sequential logic for state update
always_ff @(posedge CLK or posedge RST) begin
    if (RST) begin
        curr_state <= IDLE;
    end else begin
        curr_state <= next_state;
    end
end

// Combinational logic to determine next state and output
always_comb begin
    case (curr_state)
        IDLE: begin
            if (IN) begin
                next_state = S1;
            end else begin
                next_state = IDLE;
            end
        end
        S1: begin
            if (~IN) begin
                next_state = S2;
            end else begin
                next_state = IDLE;
            end
        end
        S2: begin
            if (~IN) begin
                next_state = S3;
            end else begin
                next_state = IDLE;
            end
        end
        S3: begin
            if (IN) begin
                next_state = S4;
            end else begin
                next_state = IDLE;
            end
        end
        S4: begin
            if (IN) begin
                next_state = S5;
            end else begin
                next_state = IDLE;
            end
        end
        S5: begin
            next_state = IDLE;  // Restart after a match
        end
        default: begin
            next_state = IDLE;
        end
    endcase
end

// Output logic
always_comb begin
    case (curr_state)
        S5: begin
            MATCH = 1'b1;  // Output 1 for one clock cycle after a match
        end
        default: begin
            MATCH = 1'b0;
        end
    endcase
end

endmodule