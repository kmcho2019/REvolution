module TopModule(
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output [99:0] q
);

reg [99:0] data_reg;
reg [6:0] index; // 7 bits can represent 0 to 127, sufficient for 100-bit rotation index

always @(posedge clk) begin
    if (load) begin
        data_reg <= data;
        index <= 0; // Reset index on load
    end else begin
        case (ena)
            2'b01: index <= (index + 99) % 100; // Right rotation
            2'b10: index <= (index + 1) % 100; // Left rotation
            default: ; // No rotation
        endcase
    end
end

// Generate output based on the current index
genvar i;
generate
    for (i = 0; i < 100; i++) begin
        assign q[i] = data_reg[(index + i) % 100];
    end
endgenerate

endmodule