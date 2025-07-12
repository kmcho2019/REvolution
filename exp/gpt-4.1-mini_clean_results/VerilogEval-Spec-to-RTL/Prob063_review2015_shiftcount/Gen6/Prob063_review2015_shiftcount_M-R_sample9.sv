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
            next_q = {q[2:0], data};  // Shift left, input at LSB (MSB-first)
        end
        else if (count_ena) begin
            next_q = q - 1;
        end
        else begin
            next_q = q; // Hold current state
        end
    end

    always @(posedge clk) begin
        q <= next_q;
    end

endmodule