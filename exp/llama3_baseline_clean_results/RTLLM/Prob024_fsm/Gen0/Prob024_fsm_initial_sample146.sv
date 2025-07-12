module fsm(
    input IN,
    input CLK,
    input RST,
    output MATCH
);

reg [2:0] state; // Current state of the FSM
reg [2:0] next_state; // Next state of the FSM
reg match_reg; // Registered output signal MATCH

// State encoding:
// S0: 3'b000
// S1: 3'b001
// S2: 3'b010
// S3: 3'b011
// S4: 3'b100
// S5: 3'b101

always @(*) begin
    case(state)
        3'b000: begin // S0
            if(IN == 1) next_state = 3'b001; // S1
            else next_state = 3'b000; // S0
        end
        3'b001: begin // S1
            if(IN == 0) next_state = 3'b010; // S2
            else next_state = 3'b001; // S1
        end
        3'b010: begin // S2
            if(IN == 0) next_state = 3'b011; // S3
            else next_state = 3'b001; // S1
        end
        3'b011: begin // S3
            if(IN == 1) next_state = 3'b100; // S4
            else next_state = 3'b000; // S0
        end
        3'b100: begin // S4
            if(IN == 1) next_state = 3'b101; // S5
            else next_state = 3'b000; // S0
        end
        3'b101: begin // S5
            if(IN == 1) next_state = 3'b101; // S5
            else next_state = 3'b000; // S0
        end
        default: next_state = 3'b000; // S0
    endcase
end

always @(posedge CLK) begin
    if(RST) begin
        state <= 3'b000; // Reset to S0
        match_reg <= 1'b0; // Reset MATCH to 0
    end
    else begin
        state <= next_state;
        if(state == 3'b101 && IN == 1) match_reg <= 1'b1; // Set MATCH to 1 when in S5 and IN is 1
        else match_reg <= 1'b0; // Set MATCH to 0 otherwise
    end
end

assign MATCH = match_reg;

endmodule