module TopModule(
    input clk,
    input a,
    output reg [2:0] q
);

// Initialize the output
initial q = 4;

// Update the current state at every positive edge of the clock
always @(posedge clk) begin
    case(q)
        3'b000: q <= (a)? 4 : 1;
        3'b001: q <= (a)? 4 : 2;
        3'b010: q <= (a)? 4 : 3;
        3'b011: q <= (a)? 4 : 4;
        3'b100: q <= (a)? 4 : 5;
        3'b101: q <= (a)? 4 : 6;
        3'b110: q <= (a)? 4 : 0;
        default: q <= 4;
    endcase
end

endmodule