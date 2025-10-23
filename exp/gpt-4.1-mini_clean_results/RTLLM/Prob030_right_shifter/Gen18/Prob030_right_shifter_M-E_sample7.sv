module right_shifter (
    input  wire       clk,
    input  wire       d,
    output reg  [7:0] q
);

initial q = 8'b0;

always @(posedge clk) begin
    reg [8:0] temp_shift;
    temp_shift = {d, q};  // Concatenate input with current register
    q <= temp_shift[8:1]; // Shift right by one and assign back to q
end

endmodule