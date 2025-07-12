module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

wire clk_en = shift_ena | count_ena;
wire [3:0] next_q;

assign next_q = shift_ena ? {q[2:0], data} :  // Shift operation
                count_ena ? q - 1'b1 :        // Count operation
                q;                             // Hold value

always @(posedge clk) begin
    if (clk_en) begin
        q <= next_q;
    end
    // Implicit else: retain value (clock gated)
end

endmodule