module TopModule(
    input clk,
    input resetn,
    input in,
    output out
);

reg [3:0] shift_register;

// Combinational logic to shift the register
wire [3:0] next_state;
assign next_state = {in, shift_register[3:1]};

always @(posedge clk) begin
    if (!resetn) begin
        shift_register <= 4'b0000;
    end else begin
        shift_register <= next_state;
    end
end

assign out = shift_register[0];

endmodule