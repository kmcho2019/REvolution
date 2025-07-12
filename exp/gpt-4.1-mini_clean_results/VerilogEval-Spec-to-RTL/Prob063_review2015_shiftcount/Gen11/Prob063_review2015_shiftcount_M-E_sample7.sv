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
            // Shift right, input data into MSB
            next_q = {data, q[3:1]};
        end
        else if (count_ena) begin
            // Decrement the register as a down-counter
            next_q = q - 4'd1;
        end
        else begin
            next_q = q; // Hold current value
        end
    end

    always @(posedge clk) begin
        q <= next_q;
    end

endmodule