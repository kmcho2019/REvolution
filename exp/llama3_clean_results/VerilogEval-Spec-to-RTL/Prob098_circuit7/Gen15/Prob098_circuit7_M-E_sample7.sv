module TopModule(
    input clk,
    input a,
    output reg q
);

reg [0:0] state; // Using a 1-bit reg to represent the two states

always @(posedge clk) 
begin
    case(state)
        1'b0: // STATE_0
            if (!a) 
                begin
                    state <= 1'b1; // Transition to STATE_1
                    q <= 1'b1; // Set q to 1
                end
            else 
                begin
                    state <= 1'b0; // Stay in STATE_0
                    q <= 1'b0; // Set q to 0
                end
        1'b1: // STATE_1
            if (!a) 
                begin
                    state <= 1'b1; // Stay in STATE_1
                    q <= 1'b1; // Set q to 1
                end
            else 
                begin
                    state <= 1'b0; // Transition to STATE_0
                    q <= 1'b0; // Set q to 0
                end
        default: 
            state <= 1'b0; // Initialize to STATE_0
            q <= 1'b0; // Initialize q to 0
    endcase
end

initial 
begin
    state <= 1'b0; // Initialize state to STATE_0
    q <= 1'b0; // Initialize q to 0
end

endmodule