module TopModule(
    input clk,
    input resetn,
    input in,
    output out
);

reg [3:0] shift_reg;

// Combinational logic to shift the register
wire [3:0] next_state;
assign next_state = {in, shift_reg[3:1]};

always @(posedge clk) begin
    if (!resetn) begin
        shift_reg <= 4'b0000;
    end else begin
        shift_reg <= next_state;
    end
end

assign out = shift_reg[0];

endmodule