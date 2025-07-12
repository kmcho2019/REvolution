module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

reg [2:0] state; // 3-bit state register to include a state for detected sequence
localparam IDLE = 3'b000; // Idle state
localparam S1 = 3'b001; // State representing prefix 1
localparam S11 = 3'b010; // State representing prefix 11
localparam S110 = 3'b011; // State representing prefix 110
localparam S1101 = 3'b100; // State representing detected sequence 1101

always @(posedge clk) begin
    if(reset) begin
        state <= IDLE; // Reset FSM to Idle state
        start_shifting <= 1'b0; // Reset start_shifting signal
    end else begin
        case(state)
            IDLE: begin
                if(data) begin
                    state <= S1; // Transition to S1 state if input bit is 1
                end else begin
                    state <= IDLE; // Stay in Idle state if input bit is 0
                end
            end
            S1: begin
                if(data) begin
                    state <= S11; // Transition to S11 state if input bit is 1
                end else begin
                    state <= IDLE; // Transition back to Idle state if input bit is 0
                end
            end
            S11: begin
                if(data) begin
                    state <= S110; // Transition to S110 state if input bit is 1
                end else begin
                    state <= S1; // Transition back to S1 state if input bit is 0
                end
            end
            S110: begin
                if(data) begin
                    state <= S110; // Incorrect in previous logic; should transition to detected state when '1' is input after '110'
                    // Corrected below
                    state <= S1101; // Transition to detected state if input bit is 1 after '110'
                end else begin
                    state <= S11; // Transition back to S11 state if input bit is 0
                end
            end
            S1101: begin
                // Stay in detected state until reset
                state <= S1101;
            end
            default: state <= IDLE; // Default case to handle invalid states
        endcase
        
        // Set start_shifting signal high when FSM reaches detected state
        if(state == S1101 && start_shifting == 1'b0) begin
            start_shifting <= 1'b1;
        end
    end
end

endmodule