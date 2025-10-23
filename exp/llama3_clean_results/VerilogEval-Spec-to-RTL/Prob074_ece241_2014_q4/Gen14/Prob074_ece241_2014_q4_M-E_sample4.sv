module TopModule(
    input clk,
    input x,
    output z
);

reg [1:0] state = 2'b00; // Use 2 bits to represent 3 states

always @(posedge clk) begin
    case (state)
        2'b00: state <= (x ^ state[0]) ? 2'b01 : 2'b00;
        2'b01: state <= (x & ~state[0]) ? 2'b10 : 2'b01;
        2'b10: state <= (x | ~state[0]) ? 2'b00 : 2'b10;
        default: state <= 2'b00;
    endcase
end

assign z = ~(state[1] | state[0]);

endmodule