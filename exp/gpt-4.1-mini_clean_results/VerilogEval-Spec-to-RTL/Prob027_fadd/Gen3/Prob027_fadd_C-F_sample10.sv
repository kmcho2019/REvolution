module TopModule (
    input  wire a,
    input  wire b,
    input  wire cin,
    output logic cout,
    output logic sum
);

    always_comb begin
        sum = a ^ b ^ cin;
        cout = (a & b) | (b & cin) | (a & cin);
    end

endmodule