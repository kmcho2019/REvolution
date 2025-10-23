module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

reg [1:0] state; // 2-bit state register
localparam IDLE = 2'b00; // Idle state
localparam S1 = 2'b01; // State representing prefix 1
localparam S11 = 2'b10; // State representing prefix 11
localparam S110 = 2'b11; // State representing prefix 110

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
                    state <= S110; // Stay in S110 state if input bit is 1
                end else begin
                    state <= S11; // Transition back to S11 state if input bit is 0
                end
            end
            default: state <= IDLE; // Default case to handle invalid states
        endcase
        
        // Set start_shifting signal high when FSM reaches S110 state and a 1 is input
        if((state == S110) && (data == 1'b1)) begin
            start_shifting <= 1'b1;
        end else if(reset) begin
            start_shifting <= 1'b0;
        end
    end
end

endmodule