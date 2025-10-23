module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output z
);

// Use attribute to guide synthesis for area and power optimization
(* area_opt, power_opt *)
reg [1:0] shift_reg;

// Asynchronous reset and sequential logic
always_ff @(posedge clk or negedge aresetn) begin
    if (!aresetn) begin
        shift_reg <= 2'b00;
    end else begin
        shift_reg <= {shift_reg[0], x};
    end
end

// Output logic
assign z = (shift_reg == 2'b10) && x;

// Add timing constraint to ensure setup and hold time requirements are met
// This should be placed in a separate file for synthesis, not in the RTL
// constraint TopModule_clk_setup { constraint_mode = mentor; 
//   create_clock -name {clk} -period 1.0;
//   set_input_delay -max 0.1 -clock {clk} {x};
//   set_output_delay -max 0.1 -clock {clk} {z};
// }

endmodule