module TopModule(
    input  [7:0] in,
    output [7:0] out
);

assign out = {in[0], in[1], in[2], in[3], in[4], in[5], in[6], in[7]};

// Alternatively, we can use a loop to make the code more concise and scalable
// However, this approach requires the use of a generate block, which is not necessary in this case

// A more concise version:
// assign out = in[7:0];

// Another way to reverse bits is by using a for loop and a always block
// But the above approach is more straightforward and efficient for this problem

endmodule