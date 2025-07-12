module fsm (
    input CLK,
    input RST,
    input IN,
    output reg MATCH
);

// Define states
parameter IDLE  = 3'b000;
parameter S1    = 3'b001;
parameter S10   = 3'b010;
parameter S100  = 3'b011;
parameter S1001 = 3'b100;
parameter S10011= 3'b101;

reg [2:0] current_state, next_state;

// State transition logic
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        current_state <= IDLE;
        MATCH <= 1'b0;
    end else begin
        current_state <= next_state;
        
        // Output logic (Mealy)
        if (current_state == S1001 && IN == 1'b1)
            MATCH <= 1'b1;
        else
            MATCH <= 1'b0;
    end
end

// Next state logic
always @(*) begin
    case (current_state)
        IDLE: begin
            if (IN == 1'b1)
                next_state = S1;
            else
                next_state = IDLE;
        end
        S1: begin
            if (IN == 1'b0)
                next_state = S10;
            else
                next_state = S1;
        end
        S10: begin
            if (IN == 1'b0)
                next_state = S100;
            else
                next_state = S1;
        end
        S100: begin
            if (IN == 1'b1)
                next_state = S1001;
            else
                next_state = IDLE;
        end
        S1001: begin
            if (IN == 1'b1)
                next_state = S10011;
            else
                next_state = S10;
        end
        S10011: begin
            if (IN == 1'b1)
                next_state = S1;
            else
                next_state = S10;
        end
        default: next_state = IDLE;
    endcase
end

endmodule