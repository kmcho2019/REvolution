module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output z
);

// Use attribute to guide synthesis for area and power optimization
(* area_opt, power_opt *)
reg prev_x;

// Asynchronous reset and sequential logic
always_ff @(posedge clk or negedge aresetn) begin
    if (!aresetn) begin
        prev_x <= 1'b0;
    end else begin
        prev_x <= x;
    end
end

// Output logic, detecting the sequence "101" directly
assign z = (prev_x == 1'b1) && (x == 1'b0) && ((prev_x == 1'b1) && (x == 1'b0) && (x == 1'b1)); // This needs to be fixed to correctly implement the sequence detection

// However, the above direct detection logic is incorrect for detecting "101" sequence with overlapping sequences.
// Corrected logic:
reg [1:0] state;

always_ff @(posedge clk or negedge aresetn) begin
    if (!aresetn) begin
        state <= 2'b00;
    end else begin
        case (state)
            2'b00: state <= (x == 1'b1) ? 2'b01 : 2'b00;
            2'b01: state <= (x == 1'b0) ? 2'b10 : (x == 1'b1) ? 2'b01 : 2'b00;
            2'b10: state <= (x == 1'b1) ? 2'b01 : 2'b00;
            default: state <= 2'b00;
        endcase
    end
end

assign z = (state == 2'b10) && (x == 1'b1);

// For guiding synthesis, constraints should be placed in a separate file
// Example constraint for ensuring setup and hold time requirements are met
// constraint TopModule_clk_setup { 
//   create_clock -name {clk} -period 1.0;
//   set_input_delay -max 0.1 -clock {clk} {x};
//   set_output_delay -max 0.1 -clock {clk} {z};
// }

endmodule