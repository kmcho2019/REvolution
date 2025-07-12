module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

reg [9:0] counter;
reg [1:0] state; // Finite State Machine states: 0 - IDLE, 1 - LOAD, 2 - COUNT
assign tc = (state == 2 && counter == 0); // Terminal count signal based on FSM state and counter value

always @(posedge clk) begin
    case(state)
        0: begin // IDLE state
            if (load) begin
                state <= 1; // Transition to LOAD state if load signal is high
            end
        end
        1: begin // LOAD state
            counter <= data; // Load counter with input data
            state <= 2; // Transition to COUNT state
        end
        2: begin // COUNT state
            if (counter > 0) begin
                counter <= counter - 1; // Decrement counter
            end else begin
                state <= 0; // Transition back to IDLE state when counter reaches zero
            end
        end
    endcase
end

endmodule