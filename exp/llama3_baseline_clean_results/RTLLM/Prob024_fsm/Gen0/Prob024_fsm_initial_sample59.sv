module fsm(
    input  logic IN,
    input  logic CLK,
    input  logic RST,
    output logic MATCH
);

// Define the sequence as a parameter
parameter SEQUENCE = 5'b10011;

// Define the states
enum logic [2:0] {
    IDLE = 3'b000,
    S1   = 3'b001,
    S2   = 3'b010,
    S3   = 3'b011,
    S4   = 3'b100,
    S5   = 3'b101
} state, next_state;

// FSM logic
always_comb begin
    case (state)
        IDLE: begin
            if (IN == 1'b1) begin
                next_state = S1;
            end else begin
                next_state = IDLE;
            end
        end
        S1: begin
            if (IN == 1'b0) begin
                next_state = S2;
            end else begin
                next_state = IDLE;
            end
        end
        S2: begin
            if (IN == 1'b0) begin
                next_state = S3;
            end else begin
                next_state = IDLE;
            end
        end
        S3: begin
            if (IN == 1'b1) begin
                next_state = S4;
            end else begin
                next_state = IDLE;
            end
        end
        S4: begin
            if (IN == 1'b1) begin
                next_state = S5;
            end else begin
                next_state = IDLE;
            end
        end
        S5: begin
            next_state = IDLE;
        end
    endcase
end

// Sequential logic
always_ff @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= IDLE;
        MATCH <= 1'b0;
    end else begin
        state <= next_state;
        if (state == S5) begin
            MATCH <= 1'b1;
        end else begin
            MATCH <= 1'b0;
        end
    end
end

endmodule