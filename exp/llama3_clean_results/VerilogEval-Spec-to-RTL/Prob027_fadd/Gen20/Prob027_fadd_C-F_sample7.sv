module TopModule(
    input a,
    input b,
    input cin,
    output reg cout,
    output reg sum
);

always @(*) begin
    sum = a ^ b ^ cin; // Direct implementation of sum logic
    cout = (a & b) | (a & cin) | (b & cin); // Direct implementation of carry-out logic
end

endmodule