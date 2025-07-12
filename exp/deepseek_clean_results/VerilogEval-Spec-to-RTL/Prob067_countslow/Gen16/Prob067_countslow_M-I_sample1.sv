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
            4'b1001: q <= 4'b0000;  // Reset after 9
            default: q <= q + 1'b1;
        endcase
    end
end

endmodule