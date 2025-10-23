module fsm(
    input  IN,
    input  CLK,
    input  RST,
    output MATCH
);

// Define states for the FSM
parameter IDLE = 4'b0000;
parameter S1 = 4'b0001;
parameter S2 = 4'b0010;
parameter S3 = 4'b0011;
parameter S4 = 4'b0100;
parameter S5 = 4'b0101;

reg [3:0] current_state; // Current state of the FSM
reg [3:0] next_state;    // Next state of the FSM

// State transition logic
always @(posedge CLK or posedge RST) begin
    if(RST) begin
        current_state <= IDLE; // Reset to initial state
    end else begin
        current_state <= next_state; // Update current state
    end
end

// Combinational logic for next state and output
always @(*) begin
    case(current_state)
        IDLE: begin
            if(IN) begin
                next_state = S1;
            end else begin
                next_state = IDLE;
            end
        end
        S1: begin
            if(!IN) begin
                next_state = S2;
            end else begin
                next_state = S1;
            end
        end
        S2: begin
            if(!IN) begin
                next_state = S3;
            end else begin
                next_state = IDLE;
            end
        end
        S3: begin
            if(IN) begin
                next_state = S4;
            end else begin
                next_state = IDLE;
            end
        end
        S4: begin
            if(IN) begin
                next_state = S5;
            end else begin
                next_state = IDLE;
            end
        end
        S5: begin
            next_state = IDLE; // Reset to initial state after match
        end
        default: begin
            next_state = IDLE;
        end
    endcase
end

// Output logic
assign MATCH = (current_state == S5)? 1'b1 : 1'b0;

endmodule