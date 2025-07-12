module fsm(
    input IN,
    input CLK,
    input RST,
    output MATCH
);

// Define states for the FSM
parameter IDLE = 4'd0,
          S1   = 4'd1,
          S2   = 4'd2,
          S3   = 4'd3,
          S4   = 4'd4,
          S5   = 4'd5;

reg [3:0] state, next_state;

// Output signal
reg MATCH_reg, MATCH_next;

always @(*) begin
    // Initialize next state and output
    MATCH_next = 1'b0;
    
    case(state)
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
                next_state = IDLE; // Reset on mismatch
            end
        end
        
        S2: begin
            if (IN == 1'b0) begin
                next_state = S3;
            end else begin
                next_state = IDLE; // Reset on mismatch
            end
        end
        
        S3: begin
            if (IN == 1'b1) begin
                next_state = S4;
            end else begin
                next_state = IDLE; // Reset on mismatch
            end
        end
        
        S4: begin
            if (IN == 1'b1) begin
                next_state = S5;
                MATCH_next = 1'b1; // Set MATCH on last '1' of sequence
            end else begin
                next_state = IDLE; // Reset on mismatch
            end
        end
        
        S5: begin
            next_state = IDLE; // Reset after match
        end
        
        default: next_state = IDLE;
    endcase
end

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= IDLE;
        MATCH_reg <= 1'b0;
    end else begin
        state <= next_state;
        MATCH_reg <= MATCH_next;
    end
end

assign MATCH = MATCH_reg;

endmodule