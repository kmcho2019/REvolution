module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

reg [1:0] state; // state register, 2 bits for 2 states, but only 1 bit is used here
reg [1:0] next_state; // next state register

// State encoding: 1 - A, 0 - B

always @(*) begin
    case(state)
        1'b0: begin // State B
            out = 1'b1;
            if (~in) next_state = 1'b1; // B (out=1) --in=0--> A
            else next_state = 1'b0; // B (out=1) --in=1--> B
        end
        1'b1: begin // State A
            out = 1'b0;
            if (~in) next_state = 1'b0; // A (out=0) --in=0--> B
            else next_state = 1'b1; // A (out=0) --in=1--> A
        end
        default: begin
            out = 1'b0;
            next_state = 1'b0;
        end
    endcase
end

always @(posedge clk) begin
    if (reset) state <= 1'b0; // Reset to state B
    else state <= next_state;
end

endmodule