module TopModule(
    input [3:0] x,
    output reg f
);

// Directly translating the conditions from the Karnaugh map into a SOP form
assign f = (x[3] &&!(x[1] == 1'b0 && x[2] == 1'b0)) || 
           (x[3] && x[1] && x[2] == 1'b0) ||
           (x[1] && x[2] && x[3] == 1'b1);

endmodule