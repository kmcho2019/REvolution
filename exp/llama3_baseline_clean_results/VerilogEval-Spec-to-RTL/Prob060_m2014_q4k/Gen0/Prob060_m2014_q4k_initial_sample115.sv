module TopModule(
    input  clk,
    input  resetn,
    input  in,
    output out
);

reg [3:0] shift_register;

always @(posedge clk) begin
    if (!resetn) begin
        shift_register <= 4'd0; // Synchronous reset
    end else begin
        shift_register <= {shift_register[2:0], in}; // Shift data
    end
end

assign out = shift_register[3]; // Output of the last flop

endmodule