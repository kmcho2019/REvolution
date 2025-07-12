module adder_bcd (
    input   [3:0] A,  // First BCD input
    input   [3:0] B,  // Second BCD input
    input       Cin, // Carry-in input
    output reg [3:0] Sum, // 4-bit output representing the sum of the two BCD inputs
    output reg      Cout  // Carry-out output
);

    // Binary adder module
    wire [4:0] bin_sum;
    assign bin_sum = A + B + Cin;

    // BCD correction module
    reg [3:0] bcd_sum;
    always @(*) begin
        if (bin_sum > 9) begin
            bcd_sum = (bin_sum[3:0] + 4'd6) % 4'd16;
        end else begin
            bcd_sum = bin_sum[3:0];
        end
    end

    // Carry generation module
    reg cout_temp;
    always @(*) begin
        if (bin_sum[4] == 1'b1) begin
            cout_temp = 1'b1;
        end else begin
            cout_temp = 1'b0;
        end
    end

    // Output assignment
    always @(*) begin
        Sum = bcd_sum;
        Cout = cout_temp;
    end

endmodule