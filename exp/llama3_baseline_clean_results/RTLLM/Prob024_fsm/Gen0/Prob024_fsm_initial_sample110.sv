module fsm(
    input  logic IN,
    input  logic CLK,
    input  logic RST,
    output logic MATCH
);

// Define the states of the FSM
parameter IDLE = 0;
parameter S1    = 1;
parameter S2    = 2;
parameter S3    = 3;
parameter S4    = 4;
parameter S5    = 5;

// Define the current state and next state
logic [2:0] current_state;
logic [2:0] next_state;

// Define the target sequence
parameter TARGET_SEQ = 5'b10011;

// Initialize the FSM
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        current_state <= IDLE;
        MATCH <= 0;
    end else begin
        current_state <= next_state;
        case (current_state)
            IDLE: begin
                if (IN == 1'b1) begin
                    next_state <= S1;
                end else begin
                    next_state <= IDLE;
                end
            end
            S1: begin
                if (IN == 1'b0) begin
                    next_state <= S2;
                end else begin
                    next_state <= IDLE;
                end
            end
            S2: begin
                if (IN == 1'b0) begin
                    next_state <= S3;
                end else begin
                    next_state <= IDLE;
                end
            end
            S3: begin
                if (IN == 1'b1) begin
                    next_state <= S4;
                end else begin
                    next_state <= IDLE;
                end
            end
            S4: begin
                if (IN == 1'b1) begin
                    next_state <= S5;
                    MATCH <= 1'b1;
                end else begin
                    next_state <= IDLE;
                end
            end
            S5: begin
                MATCH <= 1'b0;
                next_state <= IDLE;
            end
        endcase
    end
end

endmodule