module TopModule(
    input clk,
    input reset,
    input slowena,
    output [3:0] q
);

reg [3:0] count;

always @(posedge clk) begin
    if (reset) begin
        count <= 4'b0000;
    end else if (slowena) begin
        case (count)
            4'b1001: count <= 4'b0000; // Wrap around from 9 to 0
            default: count <= count + 1;
        endcase
    end
end

assign q = count;

endmodule