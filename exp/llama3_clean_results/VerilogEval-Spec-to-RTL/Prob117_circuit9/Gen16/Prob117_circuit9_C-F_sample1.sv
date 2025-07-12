module TopModule(
    input clk,
    input a,
    output reg [2:0] q
);

reg [2:0] next_q;

always @(*)
begin
    if (a) begin
        next_q = 4; // Reset q to 4 when a is high
    end else begin
        case (q)
            3'b000, 3'b001, 3'b010, 3'b011, 3'b100, 3'b101: next_q = q + 1; // Increment q
            3'b110: next_q = 0; // Wrap around to 0 after reaching 6
            default: next_q = 0; // Handle any unexpected state
        endcase
    end
end

always @(posedge clk)
    q <= next_q;

initial q = 4; // Initialize q to 4 as per the first clock cycle requirement

endmodule