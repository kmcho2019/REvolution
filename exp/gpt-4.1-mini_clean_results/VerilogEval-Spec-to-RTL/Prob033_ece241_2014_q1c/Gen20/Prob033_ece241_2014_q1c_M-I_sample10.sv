module NBitCLAAdder #(
    parameter WIDTH = 8
) (
    input  [WIDTH-1:0] a,
    input  [WIDTH-1:0] b,
    input              cin,
    output [WIDTH-1:0] sum,
    output             cout,
    output [WIDTH:0]   carry // expose full carry chain for external use
);
    wire [WIDTH-1:0] p; // propagate
    wire [WIDTH-1:0] g; // generate

    assign p = a ^ b;
    assign g = a & b;
    assign carry[0] = cin;

    // Function to calculate carry chain using carry-lookahead logic
    function [WIDTH:0] calc_carries;
        input [WIDTH-1:0] p_in;
        input [WIDTH-1:0] g_in;
        input             cin_in;
        integer i;
        reg [WIDTH:0] c_temp;
        begin
            c_temp[0] = cin_in;
            for (i = 0; i < WIDTH; i = i + 1) begin
                c_temp[i+1] = g_in[i] | (p_in[i] & c_temp[i]);
            end
            calc_carries = c_temp;
        end
    endfunction

    assign carry = calc_carries(p, g, cin);
    assign sum = p ^ carry[WIDTH-1:0];
    assign cout = carry[WIDTH];
endmodule


module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);
    wire [8:0] carry;

    // Instantiate adder with cin=0
    NBitCLAAdder #(.WIDTH(8)) cla_adder (
        .a(a),
        .b(b),
        .cin(1'b0),
        .sum(s),
        .cout(),       // not needed here
        .carry(carry)  // get full carry chain
    );

    // Overflow = carry into MSB XOR carry out of MSB
    assign overflow = carry[7] ^ carry[8];
endmodule