module TopModule(
    input [7:0] in,  // 8-bit input
    output parity   // 1-bit parity output
);

reg [7:0] temp; // Temporary register to hold the input
reg parity_temp; // Temporary register to hold the parity bit
integer i; // Loop counter

initial begin
    temp = in;
    parity_temp = 1'b0;
    for (i = 0; i < 8; i++) begin
        parity_temp = parity_temp ^ temp[7];
        temp = {temp[6:0], 1'b0}; // Shift left
    end
    parity = parity_temp;
end

endmodule