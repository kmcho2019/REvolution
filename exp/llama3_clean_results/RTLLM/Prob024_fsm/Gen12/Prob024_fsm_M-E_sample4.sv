module fsm(
    input  IN,
    input  CLK,
    input  RST,
    output MATCH
);

reg [2:0] state; // State machine with 6 states (S0 to S5)
reg [1:0] zero_count; // Counter for consecutive zeros

// State machine logic
always @(posedge CLK or posedge RST) begin
    if(RST) begin
        state <= 3'b000; // Reset state machine
        zero_count <= 2'b00; // Reset zero counter
    end else begin
        case(state)
            3'b000: begin // S0: Initial state
                if(IN) begin
                    state <= 3'b001; // Transition to S1
                end else begin
                    state <= 3'b000; // Stay in S0
                end
            end
            3'b001: begin // S1: Detected initial 1
                if(!IN) begin
                    state <= 3'b010; // Transition to S2
                    zero_count <= 2'b01; // Reset zero counter
                end else begin
                    state <= 3'b001; // Stay in S1
                end
            end
            3'b010: begin // S2: Detected first 0
                if(!IN) begin
                    state <= 3'b011; // Transition to S3
                    zero_count <= zero_count + 1; // Increment zero counter
                end else begin
                    state <= 3'b001; // Transition back to S1
                    zero_count <= 2'b00; // Reset zero counter
                end
            end
            3'b011: begin // S3: Detected second 0
                if(!IN) begin
                    state <= 3'b011; // Stay in S3
                    zero_count <= zero_count + 1; // Increment zero counter
                end else if(zero_count == 2'b10) begin
                    state <= 3'b100; // Transition to S4
                end else begin
                    state <= 3'b001; // Transition back to S1
                    zero_count <= 2'b00; // Reset zero counter
                end
            end
            3'b100: begin // S4: Detected first 1 after zeros
                if(IN) begin
                    state <= 3'b101; // Transition to S5
                end else begin
                    state <= 3'b001; // Transition back to S1
                end
            end
            3'b101: begin // S5: Detected second 1 after zeros (final state)
                state <= 3'b101; // Stay in S5
            end
        endcase
    end
end

// Combinational logic for MATCH signal
assign MATCH = (state == 3'b101) ? 1'b1 : 1'b0;

endmodule