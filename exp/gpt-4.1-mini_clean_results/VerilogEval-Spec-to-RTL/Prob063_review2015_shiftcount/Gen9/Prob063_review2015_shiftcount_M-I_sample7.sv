module TopModule(
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

    reg [3:0] next_q;

    always @(*) begin
        if (shift_ena) begin
            // Shift right to bring MSB first data in at MSB
            next_q = {data, q[3:1]};
        end
        else if (count_ena) begin
            // Decrement by adding 4'b1111 (i.e., -1)
            next_q = q + 4'b1111;
        end
        else begin
            next_q = q;
        end
    end

    always @(posedge clk) begin
        // Update only when either enable is asserted to reduce toggling
        if (shift_ena || count_ena)
            q <= next_q;
    end

endmodule