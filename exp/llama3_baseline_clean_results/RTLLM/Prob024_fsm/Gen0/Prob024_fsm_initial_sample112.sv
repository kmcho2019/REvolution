module fsm (
    input  logic IN,
    input  logic CLK,
    input  logic RST,
    output logic MATCH
);

// Define the states
parameter S0 = 0;
parameter S1 = 1;
parameter S2 = 2;
parameter S3 = 3;
parameter S4 = 4;
parameter S5 = 5;

// Current state and next state
logic [2:0] current_state;
logic [2:0] next_state;

// Set the initial state
initial current_state = S0;

// State transitions
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        current_state <= S0;
        MATCH <= 0;
    end else begin
        current_state <= next_state;
    end
end

// Next state logic
always @(*) begin
    case (current_state)
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
            if (~IN) begin
                next_state = S2;
                MATCH = 0;
            end else begin
                next_state = S1;
                MATCH = 0;
            end
        end
        S2: begin
            if (~IN) begin
                next_state = S3;
                MATCH = 0;
            end else begin
                next_state = S0;
                MATCH = 0;
            end
        end
        S3: begin
            if (IN) begin
                next_state = S4;
                MATCH = 0;
            end else begin
                next_state = S0;
                MATCH = 0;
            end
        end
        S4: begin
            if (IN) begin
                next_state = S5;
                MATCH = 0;
            end else begin
                next_state = S0;
                MATCH = 0;
            end
        end
        S5: begin
            if (IN) begin
                next_state = S1;
                MATCH = 1;
            end else begin
                next_state = S0;
                MATCH = 0;
            end
        end
    endcase
end

endmodule