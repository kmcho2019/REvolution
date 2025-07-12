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

// Use a nested loop to assign the output values
integer i, j;
always @(*) begin
    for (i = 0; i < 5; i++) begin
        for (j = 0; j < 5; j++) begin
            // Directly compare the signals using the == operator
            out[i*5 + j] = (signals[i] == signals[j]);
        end
    end
end

endmodule