module TopModule(
    input clk,
    input d,
    output reg q
);

reg q_int;  // Internal flip-flop output
wire clk_new;  // New clock signal

// Generate new clock signal
assign clk_new = clk ^ ~clk;

// Single flip-flop with new clock signal
always @(posedge clk_new) begin
    q_int <= d;
end

// Output assignment
assign q = q_int;

endmodule