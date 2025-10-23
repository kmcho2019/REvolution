module fsm(
    input  IN,
    input  CLK,
    input  RST,
    output MATCH
);

reg [2:0] state; // State machine state
reg [4:0] shift_reg; // Shift register to store last five input values

// State machine logic
always @(posedge CLK or posedge RST) begin
    if(RST) begin
        state <= 3'b000; // Reset state machine
        shift_reg <= 5'b00000; // Reset shift register
    end else begin
        case(state)
            3'b000: begin
                if(IN) begin
                    state <= 3'b001; // Transition to state S1
                end else begin
                    state <= 3'b000; // Stay in state S0
                end
                shift_reg <= {IN, shift_reg[4:1]}; // Shift input into register
            end
            3'b001: begin
                if(!IN) begin
                    state <= 3'b010; // Transition to state S2
                end else begin
                    state <= 3'b001; // Stay in state S1
                end
                shift_reg <= {IN, shift_reg[4:1]}; // Shift input into register
            end
            3'b010: begin
                if(!IN) begin
                    state <= 3'b011; // Transition to state S3
                end else begin
                    state <= 3'b001; // Transition back to state S1
                end
                shift_reg <= {IN, shift_reg[4:1]}; // Shift input into register
            end
            3'b011: begin
                if(!IN) begin
                    state <= 3'b011; // Stay in state S3
                end else begin
                    state <= 3'b100; // Transition to state S4
                end
                shift_reg <= {IN, shift_reg[4:1]}; // Shift input into register
            end
            3'b100: begin
                if(IN) begin
                    state <= 3'b101; // Transition to state S5
                end else begin
                    state <= 3'b001; // Transition back to state S1
                end
                shift_reg <= {IN, shift_reg[4:1]}; // Shift input into register
            end
            3'b101: begin
                if(IN) begin
                    state <= 3'b101; // Stay in state S5
                end else begin
                    state <= 3'b001; // Transition back to state S1
                end
                shift_reg <= {IN, shift_reg[4:1]}; // Shift input into register
            end
        endcase
    end
end

// Combinational logic for MATCH signal
assign MATCH = (shift_reg == 5'b10011) ? 1'b1 : 1'b0;

endmodule