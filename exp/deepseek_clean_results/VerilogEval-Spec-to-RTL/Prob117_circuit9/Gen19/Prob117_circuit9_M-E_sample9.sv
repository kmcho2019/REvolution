module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

always @(posedge clk) begin
    if (a) begin
        q <= 3'b100;  // Load fixed value 4 when a is high
    end else begin
        // Special rotation pattern to generate counting sequence
        case (q)
            3'b000: q <= 3'b001;  // 0 -> 1
            3'b001: q <= 3'b010;  // 1 -> 2
            3'b010: q <= 3'b011;  // 2 -> 3
            3'b011: q <= 3'b100;  // 3 -> 4
            3'b100: q <= 3'b101;  // 4 -> 5
            3'b101: q <= 3'b110;  // 5 -> 6
            3'b110: q <= 3'b000;  // 6 -> 0
            default: q <= 3'b000; // Handle undefined states
        endcase
    end
end

endmodule