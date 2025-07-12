module fsm(
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);

// Define states for each position in the sequence
enum logic [2:0] {S0, S1, S2, S3, S4} state, next_state;

// Initialize state to S0
initial state = S0;

always_ff @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= S0;
        MATCH <= 0;
    end else begin
        state <= next_state;
    end
end

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
                next_state = S4;
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