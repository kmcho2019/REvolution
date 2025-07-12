// Define a full adder module
module full_adder(
    input  a,
    input  b,
    input  cin,
    output sum,
    output cout
);
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule

// TopModule that instantiates full adders
module TopModule(
    input  [3:0] x,
    input  [3:0] y,
    output [4:0] sum
);
    wire [3:0] c;

    // Generate statement to instantiate full adders
    genvar i;
    generate
        for (i = 0; i < 4; i++) begin
            if (i == 0) begin
                full_adder fa(.a(x[i]),.b(y[i]),.cin(1'b0),.sum(sum[i]),.cout(c[i]));
            end else begin
                full_adder fa(.a(x[i]),.b(y[i]),.cin(c[i-1]),.sum(sum[i]),.cout(c[i]));
            end
        end
    endgenerate

    // Assign the final carry out as the most significant bit of sum
    assign sum[4] = c[3];

endmodule