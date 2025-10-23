module TopModule(
    input        clk,
    input        shift_ena,
    input        count_ena,
    input        data,
    output reg [3:0] q
);

    reg [3:0] next_q;

    // Compute next state combinationally
    always @(*) begin
        if (shift_ena) begin
            // Shift left (MSB first), data shifted into LSB
            next_q = {q[2:0], data};
        end else if (count_ena) begin
            // Decrement by 1 modulo 16
            next_q = q - 1;
        end else begin
            // Hold current value
            next_q = q;
        end
    end

    // Update q on positive clock edge
    always @(posedge clk) begin
        q <= next_q;
    end

endmodule