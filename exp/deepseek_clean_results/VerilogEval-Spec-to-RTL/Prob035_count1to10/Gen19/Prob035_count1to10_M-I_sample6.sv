module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 4'b0001;  // Synchronous reset to 1
    end else begin
        case (q)
            4'b1010: q <= 4'b0001;  // Wrap from 10 to 1
            default: q <= q + 1;    // Normal increment
        endcase
    end
end

endmodule