module TopModule (
    output zero
);
// Explicitly assign a constant LOW value to the output port 'zero'
// Using synthesis attribute to specify that 'zero' is a constant
(* constant = "true" *) assign zero = 1'b0;
endmodule