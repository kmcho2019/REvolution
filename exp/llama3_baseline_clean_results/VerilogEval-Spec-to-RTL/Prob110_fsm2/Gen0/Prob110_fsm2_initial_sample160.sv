module TopModule(
    input  clk,
    input  areset,
    input  j,
    input  k,
    output reg out
);

reg [0:0] state; // Using 1 bit for two states, OFF (0) and ON (1)

always @(*) begin
    if (areset) begin
        state <= 0; // Reset to OFF state
    end else begin
        case(state)
            0: state <= (j)? 1 : 0; // OFF state, transition to ON on j=1
            1: state <= (k)? 0 : 1; // ON state, transition to OFF on k=1
            default: state <= 0; // Default to OFF
        endcase
    end
end

always @(posedge clk) begin
    out <= state; // Output is the current state
end

endmodule