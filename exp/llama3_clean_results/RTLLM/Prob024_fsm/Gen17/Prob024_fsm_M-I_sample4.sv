module fsm(
    input logic IN,
    input logic CLK,
    input logic RST,
    output logic MATCH
);

// Enum for state machine states
enum logic [1:0] {
    IDLE,
    DETECT_100,
    DETECT_11
} state, next_state;

// Counter for detecting consecutive matches
logic [1:0] counter;

// Reset signal to initialize the state machine and counter
always_ff @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= IDLE;
        counter <= 2'b00;
    end else begin
        state <= next_state;
        case (state)
            IDLE: begin
                if (IN == 1'b1) begin
                    counter <= 1;
                end else begin
                    counter <= 2'b00;
                end
            end
            DETECT_100: begin
                if (IN == 1'b0) begin
                    counter <= counter + 1;
                end else if (IN == 1'b1 && counter == 2) begin
                    counter <= 1; // Restart counter for new sequence
                end else begin
                    counter <= 2'b00;
                end
            end
            DETECT_11: begin
                if (IN == 1'b1) begin
                    counter <= counter + 1;
                end else begin
                    counter <= 2'b00;
                end
            end
        endcase
    end
end

// Combinational logic for MATCH output
assign MATCH = (state == DETECT_11 && counter == 2) ? 1'b1 : 1'b0;

// Next state logic
always_comb begin
    next_state = state;
    case (state)
        IDLE: begin
            if (IN == 1'b1) begin
                next_state = DETECT_100;
            end
        end
        DETECT_100: begin
            if (counter == 2 && IN == 1'b1) begin
                next_state = DETECT_11;
            end else if (IN == 1'b1 && counter != 2) begin
                next_state = IDLE;
            end
        end
        DETECT_11: begin
            if (counter == 2) begin
                next_state = IDLE;
            end else if (IN == 1'b0) begin
                next_state = IDLE;
            end
        end
    endcase
    // Asynchronous reset for MATCH
    if (RST) begin
        MATCH = 1'b0;
    end
end

endmodule