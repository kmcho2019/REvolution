module TopModule(
    input  clk,
    input  reset,
    input  in,
    output out
);

reg [0:0] state; // Current state: 0 - A, 1 - B
reg [0:0] next_state; // Next state

always @(*) begin
    case(state)
        0: begin // State A
            out = 0;
            if(!in) next_state = 1; // in=0, go to B
            else next_state = 0; // in=1, stay in A
        end
        1: begin // State B
            out = 1;
            if(!in) next_state = 1; // in=0, stay in B
            else next_state = 1; // in=1, stay in B
        end
        default: begin
            out = 1; // Default output when in an unknown state
            next_state = 1; // Go to B by default
        end
    endcase
end

always @(posedge clk) begin
    if(reset) state <= 1; // Reset to state B when reset is high
    else state <= next_state;
end

endmodule