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
            // Shift in data at MSB, shifting right
            next_q = {data, q[3:1]};
        end else if (count_ena) begin
            // Decrement the 4-bit register by 1 modulo 16
            next_q = q - 1;
        end else begin
            next_q = q;
        end
    end

    // Sequential update of q at clock edge
    always @(posedge clk) begin
        q <= next_q;
    end

endmodule