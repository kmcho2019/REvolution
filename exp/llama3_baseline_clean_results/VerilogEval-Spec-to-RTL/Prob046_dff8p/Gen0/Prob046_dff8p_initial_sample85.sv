module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

// Define the reset value
parameter RESET_VALUE = 8'd52; // 0x34 in decimal is 52

// Use a register to store the output
reg [7:0] q_reg;

// Assign the output
assign q = q_reg;

// Initialize the register with the reset value
initial q_reg = RESET_VALUE;

// Use a always block to describe the flip-flops
always @(posedge reset or negedge clk) begin
    if(reset) begin
        q_reg <= RESET_VALUE;
    end else begin
        q_reg <= d;
    end
end

endmodule