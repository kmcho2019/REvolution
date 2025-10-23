module fsm(
    input  logic IN,
    input  logic CLK,
    input  logic RST,
    output logic MATCH
);

// Define the states of the FSM
enum logic [2:0] {
    S0 = 3'b000,
    S1 = 3'b001,
    S2 = 3'b010,
    S3 = 3'b011,
    S4 = 3'b100,
    S5 = 3'b101
} state, next_state;

// Sequential logic for the FSM
always_ff @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= S0;
    end else begin
        state <= next_state;
    end
end

// Combinational logic for the FSM
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
                next_state = S5;
            end else begin
                next_state = S0;
            end
        end
        default: begin
            next_state = S0;
        end
    endcase
end

// Output logic for MATCH
always_comb begin
    case (state)
        S5: begin
            if (IN) begin
                MATCH = 1'b1;
            end else begin
                MATCH = 1'b0;
            end
        end
        default: begin
            MATCH = 1'b0;
        end
    endcase
end

endmodule