module TopModule (
    input [1:0] A,
    input [1:0] B,
    output reg z  // reg for flexibility
);

    // Primary implementation (most readable)
    always @(*) begin
        z = (A == B);
    end

    // Alternative implementation (commented out)
    // wire [1:0] xor_result;
    // assign xor_result = A ^ B;
    // always @(*) z = ~|xor_result;

    // Optional registered version (uncomment if needed)
    // always @(posedge clk) begin
    //     z <= (A == B);
    // end

endmodule