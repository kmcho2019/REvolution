module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

reg initialized = 0;

always @(posedge clk) begin
    if (!initialized) begin
        q <= 3'b100;  // Initialize to 4 at first clock edge
        initialized <= 1;
    end else begin
        case ({a, q})
            {1'b1, 3'b???}: q <= q;  // Hold when a=1
            {1'b0, 3'b110}: q <= 3'b000;  // Wrap around after 6
            default: if (!a) q <= q + 1;  // Increment when a=0
        endcase
    end
end

endmodule