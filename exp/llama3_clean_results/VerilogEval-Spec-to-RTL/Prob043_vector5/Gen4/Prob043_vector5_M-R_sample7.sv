module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);

// Define the input signals as a wire array for easier manipulation
wire [4:0] signals = {a, b, c, d, e};

// Initialize an integer variable to keep track of the output index
integer k;

// Use a single for loop and calculate the output index
always @(*) begin
    for (k = 0; k < 25; k++) begin
        // Calculate the indices of the signals being compared
        integer i = k / 5;
        integer j = k % 5;
        
        // Directly compare the signals using the == operator
        out[k] = (signals[i] == signals[j]);
    end
end

endmodule