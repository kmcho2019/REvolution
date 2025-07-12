module TopModule (
    input x,
    input y,
    output reg z
);

reg [1:0] state;

initial begin
    z = 1'b1;  // Initial output as per waveform
    state = 2'b00;  // Initial state
end

always @(*) begin
    case(state)
        2'b00: z = (x & y) ? 1'b1 : (x ? 1'b0 : 1'b1);
        2'b01: z = (x & y) ? 1'b1 : (y ? 1'b0 : z);
        2'b10: z = (x & y) ? 1'b1 : (x ? 1'b0 : z);
        2'b11: z = (x | y) ? ((x & y) ? 1'b1 : 1'b0) : 1'b1;
    endcase
end

always @(*) begin
    state = {x, y};
end

endmodule