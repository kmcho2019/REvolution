// Refactored version using a for loop to calculate the parity
module TopModule(
    input  [7:0] in,  // 8-bit input
    output parity     // 1-bit parity output
);

reg [7:0] temp;
integer i;

always @(*) begin
    temp = 0;
    for (i = 0; i < 8; i++) begin
        temp = temp ^ in[i];
    end
    parity = temp[0];
end

endmodule