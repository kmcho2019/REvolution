module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg = 0;

// State update logic
always @(posedge clk) begin
    case ({a,b})
        2'b00: state_reg <= 1'b0;    // Reset
        2'b11: state_reg <= ~state_reg; // Toggle
        default: state_reg <= state_reg; // Hold
    endcase
end

// Output logic using continuous assignment
assign q = a ? (b ? ~state_reg : state_reg) : b;
assign state = state_reg;

endmodule