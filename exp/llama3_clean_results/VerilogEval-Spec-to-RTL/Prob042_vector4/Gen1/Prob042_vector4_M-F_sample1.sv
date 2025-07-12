module TopModule(
    input [7:0] in,
    output [31:0] out
);

assign out = {24{1'b0}, in}; // initializing with 0, then change to sign bit
assign out = (in[7] == 1'b0) ? {24{1'b0}, in} : {24{1'b1}, in}; // corrected code

// Alternatively, to make the code cleaner:
assign out = {24{in[7]}, in}; // doesn't work due to syntax issue
// Instead use
assign out = (in[7]) ? {24{1'b1}, in} : {24{1'b0}, in};

endmodule