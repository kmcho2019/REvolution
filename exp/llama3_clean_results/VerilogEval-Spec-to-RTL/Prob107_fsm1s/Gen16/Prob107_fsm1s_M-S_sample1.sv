module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

reg state; // Current state, assuming STATE_B = 0 and STATE_A = 1
always @(posedge clk) begin
    if(reset) begin
        state <= 0; // Reset to STATE_B
    end else begin
        case(state)
            0: state <= (in == 0)? 1 : 0;
            1: state <= (in == 0)? 0 : 1;
        endcase
    end
end

assign out = ~state; // Output logic based on state

endmodule