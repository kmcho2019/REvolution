module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (shift_ena | count_ena) begin
        q <= shift_ena ? {q[2:0], data} : q - 1'b1;
    end
    // q maintains value when neither is enabled
end

endmodule