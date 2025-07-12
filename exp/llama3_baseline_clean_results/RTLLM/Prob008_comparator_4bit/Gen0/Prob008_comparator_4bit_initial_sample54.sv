```thought
To implement a 4-bit comparator using combinational logic, we can use the concept of subtraction. We will perform A - B, and based on the result and the borrow, we can determine if A is greater than, equal to, or less than B. 
We will use a 4-bit full subtractor for each bit position, considering the borrow from the previous bit. 
The outputs A_greater, A_equal, and A_less will be mutually exclusive, ensuring only one of them is high at any given time.
We will use a simple logic to determine the output values based on the subtraction result and borrow.
```

```verilog
module comparator_4bit(
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// Internal wires for subtraction
wire [3:0] diff;
wire borrow;

// Perform subtraction: A - B
assign diff[0] = A[0] ? (B[0] ? 1'b0 : 1'b1) : (B[0] ? 1'b1 : 1'b0);
assign diff[1] = A[1] ? (B[1] ? (A[0] ? 1'b0 : 1'b1) : 1'b1) : (B[1] ? (A[0] ? 1'b1 : 1'b0) : 1'b0);
assign diff[2] = A[2] ? (B[2] ? (A[1] & ~B[1] || A[0] & ~A[1] & B[1]) ? 1'b0 : 1'b1 : 1'b1) : (B[2] ? (A[1] & ~B[1] || A[0] & ~A[1] & B[1]) ? 1'b1 : 1'b0 : 1'b0);
assign diff[3] = A[3] ? (B[3] ? (A[2] & ~B[2] || A[1] & ~A[2] & B[2] || A[0] & ~A[1] & B[1] & ~B[2]) ? 1'b0 : 1'b1 : 1'b1) : (B[3] ? (A[2] & ~B[2] || A[1] & ~A[2] & B[2] || A[0] & ~A[1] & B[1] & ~B[2]) ? 1'b1 : 1'b0 : 1'b0);

// Determine borrow
assign borrow = (A[0] & ~B[0]) | (~A[0] & B[0] & ~A[1]) | (~A[1] & B[1] & ~A[2]) | (~A[2] & B[2] & ~A[3]) | (B[3] & ~A[3]);

// Determine outputs based on subtraction result and borrow
assign A_greater = ~borrow & (|diff);
assign A_equal = ~(|diff);
assign A_less = borrow;

endmodule
```

--- WARNING: Parsing Issues ---
Could not parse 'code' from LLM response. Expected ```code ... ``` block.(PARSE_ERROR)
