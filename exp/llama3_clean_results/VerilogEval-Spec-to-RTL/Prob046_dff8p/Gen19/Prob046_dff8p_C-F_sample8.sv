// Define a parameterized DFF module with synchronous active high reset
module DFF #(parameter RESET_VALUE = 8'h34)(
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

reg [7:0] q_reg;

always_ff @(negedge clk) begin
    if (reset) begin
        q_reg <= RESET_VALUE;
    end else begin
        q_reg <= d;
    end
end

assign q = q_reg; // Assign output directly from register

endmodule

// TopModule instantiates the parameterized DFF
module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

DFF #(.RESET_VALUE(8'h34)) u_dff(
  .clk(clk),
  .reset(reset),
  .d(d),
  .q(q)
);

endmodule