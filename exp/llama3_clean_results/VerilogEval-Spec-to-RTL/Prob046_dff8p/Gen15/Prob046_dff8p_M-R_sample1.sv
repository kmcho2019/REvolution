// Define a D flip-flop module with active high synchronous reset
module DFF( 
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

reg [7:0] q_reg;

// Create a register to hold the reset value
reg [7:0] reset_value = 8'h34;

// Use assign to create combinational logic for reset
assign q = (reset) ? reset_value : q_reg;

// Update q_reg on the negative edge of clk
always @(negedge clk) begin
    if (!reset) begin
        q_reg <= d;
    end else begin
        q_reg <= reset_value;
    end
end

endmodule

// TopModule instantiates a single DFF to create an 8-bit register
module TopModule( 
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

DFF u_dff( 
    .clk(clk),
    .reset(reset),
    .d(d),
    .q(q)
);

endmodule