module TopModule (
    input        clk,
    input        shift_ena,
    input        count_ena,
    input        data,
    output reg [3:0] q
);

    reg [3:0] next_q;

    always @* begin
        if (shift_ena) begin
            // Shift left by 1 bit, insert new data at MSB (bit 3)
            next_q = {data, q[3:1]};
        end else if (count_ena) begin
            // Decrement by 1
            next_q = q - 1;
        end else begin
            // Hold current value
            next_q = q;
        end
    end

    always @(posedge clk) begin
        q <= next_q;
    end

endmodule