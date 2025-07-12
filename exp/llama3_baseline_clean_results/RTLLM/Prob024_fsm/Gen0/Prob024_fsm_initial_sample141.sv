module fsm(
    input logic IN,
    input logic CLK,
    input logic RST,
    output logic MATCH
);

// Define the states
parameter IDLE = 4'd0;
parameter S1 = 4'd1;
parameter S2 = 4'd2;
parameter S3 = 4'd3;
parameter S4 = 4'd4;
parameter MATCH_STATE = 4'd5;

// Define the current state and next state
logic [3:0] current_state, next_state;

// Define the sequence
parameter SEQUENCE_LENGTH = 5;
logic [SEQUENCE_LENGTH-1:0] sequence = 5'b10011;

always_comb begin
    case(current_state)
        IDLE: begin
            if (IN == sequence[0]) begin
                next_state = S1;
            end else begin
                next_state = IDLE;
            end
            MATCH = 0;
        end
        S1: begin
            if (IN == sequence[1]) begin
                next_state = S2;
            end else if (IN == sequence[0]) begin
                next_state = S1;
            end else begin
                next_state = IDLE;
            end
            MATCH = 0;
        end
        S2: begin
            if (IN == sequence[2]) begin
                next_state = S3;
            end else if (IN == sequence[0]) begin
                next_state = S1;
            end else begin
                next_state = IDLE;
            end
            MATCH = 0;
        end
        S3: begin
            if (IN == sequence[3]) begin
                next_state = S4;
            end else if (IN == sequence[0]) begin
                next_state = S1;
            end else begin
                next_state = IDLE;
            end
            MATCH = 0;
        end
        S4: begin
            if (IN == sequence[4]) begin
                next_state = MATCH_STATE;
            end else if (IN == sequence[0]) begin
                next_state = S1;
            end else begin
                next_state = IDLE;
            end
            MATCH = 0;
        end
        MATCH_STATE: begin
            MATCH = 1;
            next_state = IDLE;
        end
        default: begin
            next_state = IDLE;
            MATCH = 0;
        end
    endcase
end

always_ff @(posedge CLK or posedge RST) begin
    if (RST) begin
        current_state <= IDLE;
    end else begin
        current_state <= next_state;
    end
end

endmodule