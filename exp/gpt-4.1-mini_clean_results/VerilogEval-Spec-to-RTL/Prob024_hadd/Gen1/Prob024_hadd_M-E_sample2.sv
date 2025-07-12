module TopModule(
    input a,
    input b,
    output reg sum,
    output reg cout
);

    always @(*) begin
        sum = (a & ~b) | (~a & b); // XOR logic
        cout = a & b;
    end

endmodule