module TopModule(
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output [63:0] q
);

reg [63:0] q_reg;

// Control unit to determine shift operation
wire [1:0] shift_amount;
wire shift_left;
wire shift_right;

assign shift_amount = amount;
assign shift_left = (amount == 2'b00 || amount == 2'b01);
assign shift_right = (amount == 2'b10 || amount == 2'b11);

// Multiplexer-based barrel shifter
wire [63:0] shifted_q;
genvar i;
generate
    for (i = 0; i < 64; i++) begin
        wire [3:0] mux_sel;
        assign mux_sel = {shift_right, shift_left, shift_amount};

        always @(posedge clk) begin
            case (mux_sel)
                4'b0000: shifted_q[i] <= q_reg[i];
                4'b0001: shifted_q[i] <= (i > 0) ? q_reg[i - 1] : 1'b0;
                4'b0010: shifted_q[i] <= (i > 7) ? q_reg[i - 8] : 1'b0;
                4'b0100: shifted_q[i] <= (i < 63) ? q_reg[i + 1] : q_reg[63];
                4'b0101: shifted_q[i] <= (i < 56) ? q_reg[i + 8] : q_reg[63];
                default: shifted_q[i] <= q_reg[i];
            endcase
        end
    end
endgenerate

// Sequential logic
always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else if (ena) begin
        q_reg <= shifted_q;
    end
end

assign q = q_reg;

endmodule