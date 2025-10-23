module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

localparam RESET_VAL = 8'h34;

reg [7:0] shift_reg;

// Reset injection logic
wire [7:0] next_val = reset ? RESET_VAL : 
                     {shift_reg[6:0], shift_reg[7] ^ shift_reg[5]}; // Simple XOR feedback

// Data input muxing
wire [7:0] final_input = reset ? next_val : d;

always @(negedge clk) begin
    shift_reg <= final_input;
end

assign q = shift_reg;

endmodule