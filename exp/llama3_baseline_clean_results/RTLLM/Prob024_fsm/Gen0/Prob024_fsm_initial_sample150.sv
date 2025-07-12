module fsm(
    input  wire        IN,        // Input signal to the FSM
    input  wire        CLK,       // Clock signal used for synchronous operation
    input  wire        RST,       // Reset signal to initialize the FSM
    output reg         MATCH      // Output signal indicating a match condition based on the FSM state
);

// Define the states of the FSM
parameter IDLE = 4'b0000;
parameter S1   = 4'b0001;
parameter S2   = 4'b0010;
parameter S3   = 4'b0100;
parameter S4   = 4'b1000;
parameter S5   = 4'b1001;

reg [3:0] current_state;  // Current state of the FSM
reg [3:0] next_state;      // Next state of the FSM

// State transition logic
always @(*) begin
    case (current_state)
        IDLE: begin
            if (IN) begin
                next_state = S1;
                MATCH = 0;
            end else begin
                next_state = IDLE;
                MATCH = 0;
            end
        end
        S1: begin
            if (!IN) begin
                next_state = S2;
                MATCH = 0;
            end else begin
                next_state = IDLE;
                MATCH = 0;
            end
        end
        S2: begin
            if (!IN) begin
                next_state = S3;
                MATCH = 0;
            end else begin
                next_state = IDLE;
                MATCH = 0;
            end
        end
        S3: begin
            if (IN) begin
                next_state = S4;
                MATCH = 0;
            end else begin
                next_state = IDLE;
                MATCH = 0;
            end
        end
        S4: begin
            if (IN) begin
                next_state = S5;
                MATCH = 1;
            end else begin
                next_state = IDLE;
                MATCH = 0;
            end
        end
        S5: begin
            next_state = IDLE;
            MATCH = 0;
        end
        default: begin
            next_state = IDLE;
            MATCH = 0;
        end
    endcase
end

// Synchronous state update
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        current_state <= IDLE;
        MATCH <= 0;
    end else begin
        current_state <= next_state;
    end
end

endmodule