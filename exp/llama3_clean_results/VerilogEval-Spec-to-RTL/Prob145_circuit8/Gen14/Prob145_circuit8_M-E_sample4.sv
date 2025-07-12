module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

reg [2:0] shift_reg; // 3-bit shift register to track 'a' history

always @(posedge clock) begin
    // shift 'a' into the shift register
    shift_reg <= {shift_reg[1:0], a};

    // set 'p' high when shift register contains at least two consecutive '1's
    if (shift_reg == 3'b11 || shift_reg == 3'b111) begin
        p <= 1;
    end else begin
        p <= 0;
    end

    // set 'q' high when 'p' is high and 'a' is high
    if (p && a) begin
        q <= 1;
    end else if (clock == 1'b0) begin // reset 'q' on negative clock edge
        q <= 0;
    end
end

initial begin
    shift_reg = 3'b000;
    p = 0;
    q = 0;
end

endmodule