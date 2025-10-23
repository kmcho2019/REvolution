module TopModule(
    input clk,
    input resetn,
    input in,
    output out
);

reg [3:0] d_ff; // Declare a 4-bit register for the D flip-flops

// Initialize the output
assign out = d_ff[3]; // The output is the last bit of the shift register

// Sequential logic
always @ (posedge clk) begin
    if (!resetn) begin
        // Synchronous reset: when resetn is low, reset all flip-flops
        d_ff <= 4'b0000;
    end else begin
        // Shift the input into the first flip-flop and shift the rest of the register
        d_ff <= {in, d_ff[3:1]};
    end
end

endmodule