module TopModule (
    input clk,
    input reset,
    input slowena,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 4'b0000;
    end
    else if (slowena) begin
        case (q)
            4'b1001: q <= 4'b0000;  // Explicitly handle wrap-around at 9
            default: q <= q + 4'b0001;
        endcase
    end
end

endmodule