module TopModule(
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

reg [3:0] next_q;

always @ (*) begin
    if (shift_ena) begin
        // Shift in most significant bit
        next_q = {data, q[3:1]};
    end else if (count_ena) begin
        // Decrement the counter
        if (q == 4'b0) begin
            next_q = 4'b0; // Counter underflow, stay at 0
        end else begin
            next_q = q - 1;
        end
    end else begin
        next_q = q; // No operation, keep the current state
    end
end

always @ (posedge clk) begin
    q <= next_q;
end

endmodule