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
        2'b01: state_reg <= 1'b1;    // Set when a=0,b=1
        2'b11: state_reg <= ~state_reg; // Toggle when a=1,b=1
        default: state_reg <= state_reg; // Hold otherwise
    endcase
end

// Output logic using XOR for more accurate behavior
assign q = a ? (state_reg ^ b) : b;
assign state = state_reg;

endmodule