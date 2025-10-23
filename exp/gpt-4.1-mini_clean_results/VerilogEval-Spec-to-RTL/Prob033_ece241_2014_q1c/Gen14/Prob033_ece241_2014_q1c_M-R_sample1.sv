module NBitCLAAdder #(
    parameter WIDTH = 8
) (
    input  [WIDTH-1:0] a,
    input  [WIDTH-1:0] b,
    input              cin,
    output [WIDTH-1:0] sum,
    output             cout
);
    wire [WIDTH-1:0] p; // propagate
    wire [WIDTH-1:0] g; // generate
    wire [WIDTH:0] c;   // carries, c[0] = cin

    assign p = a ^ b;
    assign g = a & b;
    assign c[0] = cin;

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

    assign c = calc_carries(p, g, cin);
    assign sum = p ^ c[WIDTH-1:0];
    assign cout = c[WIDTH];

endmodule


module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);
    wire cout;
    wire [7:0] p = a ^ b;
    wire [7:0] g = a & b;
    wire [8:0] c;

    // Compute carry chain internally using the same function (duplicated here as local function)
    function [8:0] calc_carries_local;
        input [7:0] p_in;
        input [7:0] g_in;
        input       cin_in;
        integer i;
        reg [8:0] c_temp;
        begin
            c_temp[0] = cin_in;
            for (i = 0; i < 8; i = i + 1) begin
                c_temp[i+1] = g_in[i] | (p_in[i] & c_temp[i]);
            end
            calc_carries_local = c_temp;
        end
    endfunction

    assign c = calc_carries_local(p, g, 1'b0);

    // Instantiate adder with cin=0, get sum and cout
    NBitCLAAdder #(.WIDTH(8)) cla_adder (
        .a(a),
        .b(b),
        .cin(1'b0),
        .sum(s),
        .cout(cout)
    );

    // Overflow = carry into MSB xor carry out MSB
    assign overflow = c[7] ^ c[8];

endmodule