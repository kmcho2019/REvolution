module TopModule(
    input  in,
    output out
);

// Using a reg to store the output
reg out_reg;

// Initialize the output
initial out_reg = 1'b0;

// Using an always block to implement the NOT gate via a lookup table approach
always @(*) begin
    case (in)
        1'b0: out_reg = 1'b1;
        1'b1: out_reg = 1'b0;
    endcase
end

// Assign the output of the LUT (out_reg) to the output port
assign out = out_reg;

endmodule