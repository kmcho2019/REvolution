module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

reg [3:0] pointer = 4'b0001; // One-hot pointer initialization

always @(posedge clk) begin
    if (shift_ena) begin
        // Write data at pointer position
        case (pointer)
            4'b0001: q[3] <= data;
            4'b0010: q[2] <= data;
            4'b0100: q[1] <= data;
            4'b1000: q[0] <= data;
        endcase
        // Rotate pointer left
        pointer <= {pointer[2:0], pointer[3]};
    end
    else if (count_ena) begin
        q <= q - 1'b1;
    end
    // No else needed - q retains value if neither enable is active
end

endmodule