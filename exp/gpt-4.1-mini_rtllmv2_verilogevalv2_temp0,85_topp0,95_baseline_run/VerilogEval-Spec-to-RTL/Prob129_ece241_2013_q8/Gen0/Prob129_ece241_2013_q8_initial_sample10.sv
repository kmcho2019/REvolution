module TopModule(
    input clk,
    input aresetn,
    input x,
    output reg z
);

// State encoding
localparam S0 = 2'b00; // Initial state, no match yet
localparam S1 = 2'b01; // Matched '1'
localparam S2 = 2'b10; // Matched '10'

reg [1:0] state, next_state;

// Asynchronous negative edge reset, synchronous state update
always @(posedge clk or negedge aresetn) begin
    if (!aresetn)
        state <= S0;
    else
        state <= next_state;
end

// Next state and output logic (Mealy FSM)
always @(*) begin
    z = 0;
    case(state)
        S0: begin
            if (x)
                next_state = S1;
            else
                next_state = S0;
        end
        S1: begin
            if (x)
                next_state = S1;
            else
                next_state = S2;
        end
        S2: begin
            if (x) begin
                next_state = S1;
                z = 1; // Sequence "101" detected
            end else
                next_state = S0;
        end
        default: begin
            next_state = S0;
            z = 0;
        end
    endcase
end

endmodule