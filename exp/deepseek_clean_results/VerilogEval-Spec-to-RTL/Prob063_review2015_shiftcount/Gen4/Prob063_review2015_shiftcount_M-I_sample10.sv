module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

wire [3:0] next_q;

// Combined operation selection
assign next_q = shift_ena ? {q[2:0], data} : 
                count_ena ? q - 1'b1 : 
                q;

// Clock gating implementation
always @(posedge clk) begin
    if (shift_ena | count_ena) begin
        q <= next_q;
    end
    // Else maintain current value (implicit)
end

endmodule