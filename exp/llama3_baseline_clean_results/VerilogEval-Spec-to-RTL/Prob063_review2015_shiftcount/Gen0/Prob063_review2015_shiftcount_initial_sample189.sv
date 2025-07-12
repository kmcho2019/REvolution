module TopModule(
    input  clk,
    input  shift_ena,
    input  count_ena,
    input  data,
    output [3:0] q
);

reg [3:0] register_q;

always @ (posedge clk) begin
    if (shift_ena) begin
        // Shift in new data from most significant bit
        register_q <= {data, register_q[3:1]};
    end else if (count_ena) begin
        // Decrement the current number in the shift register
        if (register_q == 0) begin
            register_q <= 0;  // Don't decrement below 0
        end else begin
            register_q <= register_q - 1;
        end
    end
end

assign q = register_q;

endmodule