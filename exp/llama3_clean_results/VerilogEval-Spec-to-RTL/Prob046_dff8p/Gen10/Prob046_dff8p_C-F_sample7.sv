// Define a single D flip-flop module with active high synchronous reset
module DFF(
    input clk,
    input reset,
    input d,
    output q
);

parameter RESET_VALUE = 1'b0; // Default reset value

reg q_reg;

always @(negedge clk) begin
    if (reset) begin
        q_reg <= RESET_VALUE;
    end else begin
        q_reg <= d;
    end
end

assign q = q_reg;

endmodule

// TopModule instantiates 8 DFFs to create an 8-bit register
module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

reg [7:0] data_out;

// Define the reset value as a parameter for clarity and ease of modification
parameter RESET_VALUE = 8'h34;

// Instantiate 8 DFFs with the desired reset value
genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin
        DFF #(.RESET_VALUE(RESET_VALUE[i])) u_dff(
            .clk(clk),
            .reset(reset),
            .d(d[i]),
            .q(data_out[i])
        );
    end
endgenerate

// Assign the output directly from the internal register
assign q = data_out;

endmodule