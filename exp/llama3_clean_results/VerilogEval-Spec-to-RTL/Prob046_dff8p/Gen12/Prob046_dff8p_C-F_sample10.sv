// Define a parameterized D flip-flop module with active high synchronous reset
module DFF #(parameter WIDTH = 1, parameter RESET_VALUE = 1)( // Parameters for width and reset value
    input clk,
    input reset,
    input [WIDTH-1:0] d,
    output [WIDTH-1:0] q
);

reg [WIDTH-1:0] q_reg;

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
module TopModule #(parameter RESET_VALUE = 8'h34)( // Parameter for reset value
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

reg [7:0] data_out;

// Instantiate 8 DFFs with the desired reset value
genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin
        DFF #(.WIDTH(1), .RESET_VALUE(RESET_VALUE[i])) u_dff(
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