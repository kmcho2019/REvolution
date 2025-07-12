module fsm(
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);

// Define states for the FSM
parameter   IDLE       = 4'b0000,
            ONE        = 4'b0001,
            ZERO1      = 4'b0010,
            ZERO2      = 4'b0100,
            ONE2       = 4'b1000,
            ONE3       = 4'b1001;

reg [3:0] current_state, next_state;

// Sequential logic
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        current_state <= IDLE;
        MATCH <= 0;
    end else begin
        current_state <= next_state;
        if (current_state == ONE3)
            MATCH <= 1;
        else
            MATCH <= 0;
    end
end

// Combinational logic
always @(*) begin
    case (current_state)
        IDLE: begin
            if (IN)
                next_state = ONE;
            else
                next_state = IDLE;
        end
        ONE: begin
            if (~IN)
                next_state = ZERO1;
            else
                next_state = ONE;
        end
        ZERO1: begin
            if (~IN)
                next_state = ZERO2;
            else
                next_state = ONE;
        end
        ZERO2: begin
            if (IN)
                next_state = ONE2;
            else
                next_state = ZERO1;
        end
        ONE2: begin
            if (IN)
                next_state = ONE3;
            else
                next_state = ZERO1;
        end
        ONE3: begin
            if (IN)
                next_state = ONE;
            else
                next_state = ZERO1;
        end
        default: next_state = IDLE;
    endcase
end

endmodule