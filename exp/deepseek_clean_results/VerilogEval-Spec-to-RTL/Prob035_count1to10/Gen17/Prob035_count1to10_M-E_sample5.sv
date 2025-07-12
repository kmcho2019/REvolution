module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

reg [3:0] j_counter;  // Johnson counter register

always @(posedge clk) begin
    if (reset) begin
        j_counter <= 4'b0000;
    end
    else begin
        // Standard Johnson counter operation
        j_counter <= {~j_counter[0], j_counter[3:1]};
    end
end

// Convert Johnson counter states to 1-10 sequence
always @(*) begin
    case (j_counter)
        4'b0000: q = 4'b0001;  // 1
        4'b1000: q = 4'b0010;  // 2
        4'b1100: q = 4'b0011;  // 3
        4'b1110: q = 4'b0100;  // 4
        4'b1111: q = 4'b0101;  // 5
        4'b0111: q = 4'b0110;  // 6
        4'b0011: q = 4'b0111;  // 7
        4'b0001: q = 4'b1000;  // 8
        4'b1001: q = 4'b1001;  // 9
        4'b1101: q = 4'b1010;  // 10
        default: q = 4'b0001;  // Should never occur
    endcase
end

endmodule