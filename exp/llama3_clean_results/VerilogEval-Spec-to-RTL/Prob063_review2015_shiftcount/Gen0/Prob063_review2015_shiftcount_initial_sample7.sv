module TopModule(
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

always @ (posedge clk) begin
    if (shift_ena) begin
        // Shift in most significant bit
        q = {data, q[3:1]};
    end else if (count_ena) begin
        // Decrement the counter
        if (q == 4'b0) begin
            q = 4'b0; // Counter underflow, stay at 0
        end else begin
            q = q - 1;
        end
    end
end

endmodule