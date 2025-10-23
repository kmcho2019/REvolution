module fsm(
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);

// Define states using binary encoding
typedef enum logic [2:0] {
    IDLE = 3'b000,
    S1   = 3'b001,
    S2   = 3'b010,
    S3   = 3'b011,
    S4   = 3'b100,
    S5   = 3'b101
} state_t;

state_t current_state, next_state;

// Use assign statement for output logic
assign MATCH = (current_state == S5) ? 1'b1 : 1'b0;

// Single always block for state transition
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        current_state <= IDLE;
    end else begin
        case (current_state)
            IDLE: begin
                if (IN) begin
                    current_state <= S1;
                end else begin
                    current_state <= IDLE;
                end
            end
            S1: begin
                if (!IN) begin
                    current_state <= S2;
                end else begin
                    current_state <= IDLE;
                end
            end
            S2: begin
                if (!IN) begin
                    current_state <= S3;
                end else begin
                    current_state <= IDLE;
                end
            end
            S3: begin
                if (IN) begin
                    current_state <= S4;
                end else begin
                    current_state <= IDLE;
                end
            end
            S4: begin
                if (IN) begin
                    current_state <= S5;
                end else begin
                    current_state <= IDLE;
                end
            end
            S5: begin
                current_state <= IDLE;
            end
            default: current_state <= IDLE;
        endcase
    end
end

endmodule