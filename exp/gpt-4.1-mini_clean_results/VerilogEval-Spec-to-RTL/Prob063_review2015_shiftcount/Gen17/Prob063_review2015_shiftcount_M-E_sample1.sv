module TopModule (
    input        clk,
    input        shift_ena,
    input        count_ena,
    input        data,
    output reg [3:0] q
);

// Internal enable signals
wire shift_en;
wire count_en;

assign shift_en = shift_ena;
assign count_en = count_ena & ~shift_ena; // ensure mutually exclusive operation

always @(posedge clk) begin
    if (shift_en)
        q <= {q[2:0], data};  // Shift in MSB first
    else if (count_en)
        q <= q - 1;          // Decrement
    // else retain q (no assignment)
end

endmodule