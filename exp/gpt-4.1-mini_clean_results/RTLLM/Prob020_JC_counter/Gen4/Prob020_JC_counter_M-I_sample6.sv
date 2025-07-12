module JC_counter (
    input  wire        clk,
    input  wire        rst_n,
    output reg [63:0]  Q
);

// Feedback bit is complement of LSB
wire feedback_bit = ~Q[0];

// Synchronous reset for better timing and power
always @(posedge clk) begin
    if (!rst_n)
        Q <= 64'b0;
    else
        Q <= {feedback_bit, Q[63:1]};
end

// Synthesis attribute to encourage shift register mapping (tool specific, example for Synopsys)
//(* shift_register = "true" *) reg [63:0] Q;

endmodule