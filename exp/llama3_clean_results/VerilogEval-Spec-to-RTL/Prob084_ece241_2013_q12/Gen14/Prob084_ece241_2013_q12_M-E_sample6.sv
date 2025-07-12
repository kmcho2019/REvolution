module TopModule(
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output reg Z
);

reg [7:0] Q; // Register file to store the 8 bits of data
reg [2:0] wp; // Write pointer to control the circular buffer

always @(posedge clk) begin
    if (enable) begin
        // Shift the data in a circular manner
        Q <= {Q[6:0], S};
        // Update the write pointer
        wp <= (wp == 3'b111) ? 3'b000 : wp + 1'b1;
    end
end

always @(*) begin
    // Use a 3-to-8 decoder to select the desired bit
    case ({A, B, C})
        3'b000: Z = Q[0];
        3'b001: Z = Q[1];
        3'b010: Z = Q[2];
        3'b011: Z = Q[3];
        3'b100: Z = Q[4];
        3'b101: Z = Q[5];
        3'b110: Z = Q[6];
        3'b111: Z = Q[7];
        default: Z = 1'bx;
    endcase
end

endmodule