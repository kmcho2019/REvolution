module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Combined address for ROM lookup
    wire [8:0] rom_address = {A, B, Cin};

    // ROM implementation using case statement
    reg [4:0] rom[0:511]; // 5-bit output: {Cout, Sum}

    // Initialize ROM with precomputed values
    integer i;
    initial begin
        for (i = 0; i < 512; i = i + 1) begin
            // Extract inputs from address
            automatic logic [3:0] a = i[8:5];
            automatic logic [3:0] b = i[4:1];
            automatic logic cin = i[0];
            automatic logic [4:0] binary_sum = a + b + cin;
            
            // BCD correction logic
            if (binary_sum > 9) begin
                rom[i] = {1'b1, binary_sum[3:0] + 4'd6};
            end else begin
                rom[i] = {1'b0, binary_sum[3:0]};
            end
        end
    end

    // Output assignment
    assign {Cout, Sum} = rom[rom_address];

endmodule