module adder_bcd(
    input  wire [3:0] A,  // First BCD input
    input  wire [3:0] B,  // Second BCD input
    input  wire Cin,      // Carry-in input
    output wire [3:0] Sum, // 4-bit output representing the sum
    output wire Cout       // Carry-out output
);

    // Perform binary addition of A, B, and Cin
    reg [4:0] temp_sum;
    always @(A, B, Cin) begin
        temp_sum = {1'b0, A} + {1'b0, B} + Cin;
    end

    // Apply BCD correction if sum exceeds 9
    reg [3:0] corrected_sum;
    always @(temp_sum) begin
        if (temp_sum > 4'd9) begin
            corrected_sum = temp_sum + 4'd6;
        end else begin
            corrected_sum = temp_sum[3:0];
        end
    end

    // Generate carry-out signal if result exceeds 9
    always @(temp_sum) begin
        if (temp_sum > 4'd9) begin
            Cout = 1'b1;
        end else begin
            Cout = 1'b0;
        end
    end

    // Assign output Sum
    assign Sum = corrected_sum;

endmodule