module TopModule(
    input         clk,
    input         shift_ena,
    input         count_ena,
    input         data,
    output reg [3:0] q
);

    reg [3:0] next_q;

    always @(*) begin
        if (shift_ena) begin
            // Shift left by 1, insert data at LSB (MSB-first)
            next_q = {q[2:0], data};
        end
        else if (count_ena) begin
            // Decrement q by 1 modulo 16
            next_q = q + 4'b1111;
        end
        else begin
            // Hold the current value
            next_q = q;
        end
    end

    // Update q on positive clock edge
    always @(posedge clk) begin
        q <= next_q;
    end

endmodule