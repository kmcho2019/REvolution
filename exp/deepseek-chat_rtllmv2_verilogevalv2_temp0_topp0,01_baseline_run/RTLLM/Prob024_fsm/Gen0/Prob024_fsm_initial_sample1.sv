module fsm (
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);

// Define states
parameter S0 = 3'b000;
parameter S1 = 3'b001;
parameter S2 = 3'b010;
parameter S3 = 3'b011;
parameter S4 = 3'b100;
parameter S5 = 3'b101;

reg [2:0] current_state, next_state;

// State transition logic
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        current_state <= S0;
    end else begin
        current_state <= next_state;
    end
end

// Next state and output logic
always @(*) begin
    case (current_state)
        S0: begin
            MATCH = 0;
            if (IN) next_state = S1;
            else next_state = S0;
        end
        S1: begin
            MATCH = 0;
            if (!IN) next_state = S2;
            else next_state = S1;
        end
        S2: begin
            MATCH = 0;
            if (!IN) next_state = S3;
            else next_state = S1;
        end
        S3: begin
            MATCH = 0;
            if (IN) next_state = S4;
            else next_state = S0;
        end
        S4: begin
            MATCH = 0;
            if (IN) next_state = S5;
            else next_state = S2;
        end
        S5: begin
            MATCH = 1;
            if (IN) next_state = S1;
            else next_state = S2;
        end
        default: begin
            MATCH = 0;
            next_state = S0;
        end
    endcase
end

endmodule