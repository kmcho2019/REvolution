module TopModule (
    output zero
);
// Define the output as a wire and then use a continuous assignment
wire zero;
assign zero = 1'b0;
endmodule