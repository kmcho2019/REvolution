module TopModule(
    input        clk,
    input        shift_ena,
    input        count_ena,
    input        data,
    output reg [3:0] q
);

    reg [3:0] next_q;

    always @(*) begin
        if (shift_ena) begin
            // Shift left (MSB first), input data into LSB
            next_q = {q[2:0], data};
        end
        else if (count_ena) begin
            // Decrement q by 1 with wrap-around
            next_q = q - 4'd1;
        end
        else begin
            next_q = q;
        end
    end

    always @(posedge clk) begin
        q <= next_q;
    end

endmodule