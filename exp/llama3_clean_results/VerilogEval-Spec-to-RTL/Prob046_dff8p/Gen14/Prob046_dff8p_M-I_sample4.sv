// Define a parameterized D flip-flop module with active high synchronous reset
module DFF #(parameter WIDTH = 1)( // WIDTH parameter for data and reset value
    input clk,
    input reset,
    input [WIDTH-1:0] d,
    input [WIDTH-1:0] reset_value,
    output [WIDTH-1:0] q
);

reg [WIDTH-1:0] q_reg;

always @(negedge clk) begin
    if (reset) begin
        q_reg <= reset_value;
    end else begin
        q_reg <= d;
    end
end

assign q = q_reg;

endmodule

// TopModule instantiates 8 DFFs to create an 8-bit register
module TopModule #(parameter RESET_VALUE = 8'h34)( // Parameter for reset value
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

// Instantiate 8 DFFs
genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin
        DFF #(.WIDTH(1)) u_dff( // Instantiate DFF with WIDTH=1 for each bit
            .clk(clk),
            .reset(reset),
            .d(d[i]),
            .reset_value(RESET_VALUE[i]), // Use parameterized reset value
            .q(q[i])
        );
    end
endgenerate

endmodule