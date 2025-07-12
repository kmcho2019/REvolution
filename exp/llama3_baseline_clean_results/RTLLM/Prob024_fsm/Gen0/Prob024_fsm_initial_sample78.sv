module fsm(
    input  logic IN,
    input  logic CLK,
    input  logic RST,
    output logic MATCH
);

// Define the states of the FSM
localparam [2:0] IDLE = 3'b000;  // Initial state
localparam [2:0] S1   = 3'b001;  // State 1: Input 1
localparam [2:0] S2   = 3'b010;  // State 2: Input 0
localparam [2:0] S3   = 3'b011;  // State 3: Input 0
localparam [2:0] S4   = 3'b100;  // State 4: Input 1
localparam [2:0] S5   = 3'b101;  // State 5: Input 1

reg [2:0] state;  // Current state
reg [2:0] next_state;  // Next state

// Assign the output signal MATCH
always @(*) begin
    case (state)
        IDLE: MATCH = 0;
        S1:   MATCH = 0;
        S2:   MATCH = 0;
        S3:   MATCH = 0;
        S4:   MATCH = 0;
        S5:   MATCH = (IN == 1)? 1 : 0;
        default: MATCH = 0;
    endcase
end

// Update the state on the positive edge of the clock signal
always @(posedge CLK) begin
    if (RST) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

// Calculate the next state
always @(*) begin
    case (state)
        IDLE: begin
            if (IN == 1) begin
                next_state = S1;
            end else begin
                next_state = IDLE;
            end
        end
        S1: begin
            if (IN == 0) begin
                next_state = S2;
            end else begin
                next_state = IDLE;
            end
        end
        S2: begin
            if (IN == 0) begin
                next_state = S3;
            end else begin
                next_state = IDLE;
            end
        end
        S3: begin
            if (IN == 1) begin
                next_state = S4;
            end else begin
                next_state = IDLE;
            end
        end
        S4: begin
            if (IN == 1) begin
                next_state = S5;
            end else begin
                next_state = IDLE;
            end
        end
        S5: begin
            if (IN == 1) begin
                next_state = S5;
            end else begin
                next_state = IDLE;
            end
        end
        default: next_state = IDLE;
    endcase
end

endmodule