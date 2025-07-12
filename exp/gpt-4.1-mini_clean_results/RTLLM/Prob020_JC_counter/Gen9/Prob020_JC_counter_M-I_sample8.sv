module JC_counter (
    input  wire       clk,
    input  wire       rst_n,
    output reg [63:0] Q
);

// Synthesis attribute to encourage shift register inference (tool dependent)
// For example, in Synopsys or Vivado:
// (* shift_register = "yes" *)

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Q <= 64'b0;
    end else begin
        Q <= {~Q[0], Q[63:1]};  // shift right by 1, insert inverted Q[0] at MSB
    end
end

endmodule