module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

reg state; // State variable

always @(posedge clk) begin
    if(reset) begin
        state <= 0; // Reset to state B (out=1)
    end else begin
        case(state)
            0: state <= in ? 0 : 1;
            1: state <= in ? 1 : 0;
            default: state <= 0; // Default state
        endcase
    end
end

assign out = ~state; // Output directly related to the state

endmodule