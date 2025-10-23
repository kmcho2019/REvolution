module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // First stage: Binary addition of A, B, and Cin
    wire [4:0] bin_sum = A + B + Cin;

    // State variable for the FSM
    reg [1:0] state;
    parameter valid_BCD = 2'b00, correct_and_carry = 2'b01;

    // Next state logic
    always @(posedge bin_sum) begin
        if (bin_sum <= 9) begin
            state <= valid_BCD;
        end else begin
            state <= correct_and_carry;
        end
    end

    // Output logic
    always @(state, bin_sum) begin
        case (state)
            valid_BCD: begin
                Sum = bin_sum[3:0];
                Cout = 0;
            end
            correct_and_carry: begin
                Sum = (bin_sum[3:0] + 4'd6);
                Cout = 1;
            end
        endcase
    end

endmodule