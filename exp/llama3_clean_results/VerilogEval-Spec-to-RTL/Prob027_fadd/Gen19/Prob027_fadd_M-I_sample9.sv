// Improved implementation of TopModule
module TopModule(
    input a,
    input b,
    input cin,
    output cout,
    output sum
);

// Direct implementation of sum logic
assign sum = a ^ b ^ cin;

// Direct implementation of carry-out logic
assign cout = (a & b) | (a & cin) | (b & cin);

endmodule