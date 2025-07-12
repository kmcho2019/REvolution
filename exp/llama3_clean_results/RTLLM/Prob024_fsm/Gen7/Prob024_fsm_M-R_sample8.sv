module fsm(
    input logic IN,
    input logic CLK,
    input logic RST,
    output logic MATCH
);

// Enumerated type for the states
enum logic [1:0] {
    IDLE,
    S1,
    S2,
    S3
} state, next_state;

// Asynchronous reset and synchronous logic
always_ff @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

// Combinational logic
always_comb begin
    case (state)
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
                next_state = S2;
            end else begin
                next_state = S3;
            end
        end
        S3: begin
            if (IN) begin
                next_state = IDLE;
                MATCH = 1'b1;
            end else begin
                next_state = IDLE;
                MATCH = 1'b0;
            end
        end
    endcase
    // If state is not S3, MATCH should be 0
    if (state != S3) begin
        MATCH = 1'b0;
    end
end

endmodule