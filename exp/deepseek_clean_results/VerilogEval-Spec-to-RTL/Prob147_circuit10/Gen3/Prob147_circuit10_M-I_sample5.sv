module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg = 0;  // Initialize state to 0
reg q_out;

always @(posedge clk) begin
    // Improved state transition logic
    case ({a,b})
        2'b00: state_reg <= 1'b0;    // Reset state when a=0,b=0
        2'b11: state_reg <= ~state_reg; // Toggle when a=1,b=1
        default: state_reg <= state_reg; // Maintain state otherwise
    endcase
end

always @(*) begin
    // Improved output logic
    if (a) begin
        q_out = b ^ state_reg;  // XOR operation
    end else begin
        q_out = b;
    end
end

assign q = q_out;
assign state = state_reg;

endmodule