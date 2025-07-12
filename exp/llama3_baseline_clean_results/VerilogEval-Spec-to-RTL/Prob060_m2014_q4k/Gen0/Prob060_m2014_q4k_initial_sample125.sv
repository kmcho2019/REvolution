module TopModule (
    input clk,
    input resetn,
    input in,
    output out
);

reg [3:0] shift_register;

always @(posedge clk) begin
    if (!resetn) begin
        // Synchronous reset: clear shift register
        shift_register <= 4'b0000;
    end else begin
        // Shift input into shift register
        shift_register <= {in, shift_register[3:1]};
    end
end

// Assign output to last bit of shift register
assign out = shift_register[0];

endmodule