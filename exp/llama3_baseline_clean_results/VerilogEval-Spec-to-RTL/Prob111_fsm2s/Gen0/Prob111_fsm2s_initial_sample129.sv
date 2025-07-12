module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output out
);

parameter OFF = 1'b0;
parameter ON  = 1'b1;

reg current_state;

always @(posedge clk) begin
    if (reset) begin
        current_state <= OFF;
    end else begin
        case (current_state)
            OFF: current_state <= j ? ON : OFF;
            ON:  current_state <= k ? ON : OFF;
            default: current_state <= OFF; // default to OFF state
        endcase
    end
end

assign out = current_state;

endmodule