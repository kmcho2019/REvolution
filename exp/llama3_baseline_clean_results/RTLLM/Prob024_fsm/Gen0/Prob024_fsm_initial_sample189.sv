module fsm(
    input IN,
    input CLK,
    input RST,
    output MATCH
);

// Define states for the FSM
parameter IDLE = 4'd0;
parameter S1 = 4'd1;
parameter S2 = 4'd2;
parameter S3 = 4'd3;
parameter S4 = 4'd4;
parameter S5 = 4'd5;

// Current state and next state
reg [3:0] current_state;
reg [3:0] next_state;

// Output signal
reg MATCH_reg;

// FSM state transitions
always @(*) begin
    case(current_state)
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
            next_state = IDLE;
        end
        default: next_state = IDLE;
    endcase
end

// Set MATCH signal based on current state
always @(*) begin
    if (current_state == S5) begin
        MATCH_reg = 1;
    end else begin
        MATCH_reg = 0;
    end
end

// Sequential logic
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        current_state <= IDLE;
        MATCH_reg <= 0;
    end else begin
        current_state <= next_state;
    end
end

// Continuous assignment for output
assign MATCH = MATCH_reg;

endmodule