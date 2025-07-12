module right_shifter (
    input wire clk,
    input wire d,
    output reg [7:0] q
);

// Internal pipeline registers
reg [7:0] shift_stage;
reg [7:0] output_stage;

// Control signals
wire load_enable = 1'b0;  // Not used in basic version but available for expansion

// Shift operation pipeline
always @(posedge clk) begin
    // First pipeline stage: perform the shift
    if (load_enable) begin
        shift_stage <= 8'h00;  // Parallel load capability
    end else begin
        shift_stage <= {d, shift_stage[7:1]};  // Right shift with new MSB
    end
    
    // Second pipeline stage: registered output
    output_stage <= shift_stage;
end

// Continuous output assignment
assign q = output_stage;

// Initialization
initial begin
    shift_stage = 8'h00;
    output_stage = 8'h00;
end

endmodule