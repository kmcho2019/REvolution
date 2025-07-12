module fsm(
    input  IN,
    input  CLK,
    input  RST,
    output MATCH
);

reg [1:0] state_machine1; // State machine 1: detects initial 1
reg [2:0] state_machine2; // State machine 2: detects 001 sequence
reg [1:0] state_machine3; // State machine 3: detects final 11 sequence

// State machine 1 logic
always @(posedge CLK or posedge RST) begin
    if(RST) begin
        state_machine1 <= 2'b00; // Reset state machine 1
    end else begin
        case(state_machine1)
            2'b00: begin
                if(IN) begin
                    state_machine1 <= 2'b01; // Transition to state S1
                end else begin
                    state_machine1 <= 2'b00; // Stay in state S0
                end
            end
            2'b01: begin
                if(IN) begin
                    state_machine1 <= 2'b01; // Stay in state S1
                end else begin
                    state_machine1 <= 2'b00; // Transition back to state S0
                end
            end
        endcase
    end
end

// State machine 2 logic
always @(posedge CLK or posedge RST) begin
    if(RST) begin
        state_machine2 <= 3'b000; // Reset state machine 2
    end else begin
        case(state_machine2)
            3'b000: begin
                if(!IN) begin
                    state_machine2 <= 3'b001; // Transition to state S1
                end else begin
                    state_machine2 <= 3'b000; // Stay in state S0
                end
            end
            3'b001: begin
                if(!IN) begin
                    state_machine2 <= 3'b001; // Stay in state S1
                end else begin
                    state_machine2 <= 3'b010; // Transition to state S2
                end
            end
            3'b010: begin
                if(!IN) begin
                    state_machine2 <= 3'b001; // Transition back to state S1
                end else begin
                    state_machine2 <= 3'b010; // Stay in state S2
                end
            end
        endcase
    end
end

// State machine 3 logic
always @(posedge CLK or posedge RST) begin
    if(RST) begin
        state_machine3 <= 2'b00; // Reset state machine 3
    end else begin
        case(state_machine3)
            2'b00: begin
                if(IN) begin
                    state_machine3 <= 2'b01; // Transition to state S1
                end else begin
                    state_machine3 <= 2'b00; // Stay in state S0
                end
            end
            2'b01: begin
                if(IN) begin
                    state_machine3 <= 2'b01; // Stay in state S1
                end else begin
                    state_machine3 <= 2'b00; // Transition back to state S0
                end
            end
        endcase
    end
end

// Combinational logic for MATCH signal
assign MATCH = (state_machine1 == 2'b01 && state_machine2 == 3'b010 && state_machine3 == 2'b01)? 1'b1 : 1'b0;

endmodule