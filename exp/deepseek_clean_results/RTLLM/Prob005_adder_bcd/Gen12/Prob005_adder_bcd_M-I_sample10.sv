module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Binary addition stage
    wire [3:0] sum_uncorrected = A + B + Cin;
    wire raw_carry = (A + B + Cin) > 4'd9;  // Direct overflow detection
    
    // Pre-compute both possible results
    wire [3:0] sum_corrected = sum_uncorrected + 4'd6;
    
    // Output selection
    assign Sum = raw_carry ? sum_corrected : sum_uncorrected;
    assign Cout = raw_carry;

    /* Alternative implementation for synchronous systems with clock gating
    reg [3:0] sum_reg;
    reg cout_reg;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_reg <= 4'b0;
            cout_reg <= 1'b0;
        end
        else if (enable) begin  // Clock gating control
            sum_reg <= raw_carry ? sum_corrected : sum_uncorrected;
            cout_reg <= raw_carry;
        end
    end
    assign Sum = sum_reg;
    assign Cout = cout_reg;
    */
endmodule