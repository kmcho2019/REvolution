module TopModule (
    input        clk,
    input        shift_ena,
    input        count_ena,
    input        data,
    output reg [3:0] q
);

reg [3:0] next_q;

always @(*) begin
    if (shift_ena) begin
        // Shift left (MSB-first), input data at LSB
        next_q = {q[2:0], data};
    end else if (count_ena) begin
        // Decrement the 4-bit value
        next_q = q - 1;
    end else begin
        // Hold current state
        next_q = q;
    end
end

always @(posedge clk) begin
    if (shift_ena || count_ena) begin
        q <= next_q;
    end
    // else q holds its previous value implicitly
end

endmodule