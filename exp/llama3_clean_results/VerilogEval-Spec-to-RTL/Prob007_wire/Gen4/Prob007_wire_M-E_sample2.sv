module TopModule(
    input  in,
    output reg out
);

// Use a combinational always block to assign the input to the output
always @(*) begin
    out = in;
end

endmodule