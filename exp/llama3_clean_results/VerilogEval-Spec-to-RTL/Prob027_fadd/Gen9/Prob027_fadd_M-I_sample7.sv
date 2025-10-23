module TopModule(
    input a,
    input b,
    input cin,
    output reg cout,
    output reg sum
);

always @(*) begin
    sum = a ^ b ^ cin; // Sum calculation remains the same
    // Alternative structure for carry-out using the same logic but potentially more efficient in certain technologies
    cout = (a & b) | ((a ^ b) & cin);
end

endmodule