module TopModule(
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output reg Z
);

reg [7:0] memory; // LUT to store memory contents

always @(posedge clk) begin
    if (enable) begin
        // Shift memory contents to the right
        memory[7:1] = memory[6:0];
        memory[0] = S;
    end
end

// Use the inputs A, B, and C to index into the memory
assign Z = memory[{A, B, C}];

endmodule