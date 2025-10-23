// Basic shift register module
module shift_register(
    input clk,
    input reset,
    input [4:0] in,
    output [4:0] out
);

reg [4:0] reg_out;

always @(posedge clk) begin
    if (reset) begin
        reg_out <= 5'b00000;
    end else begin
        reg_out <= {in[3:0], in[4]};
    end
end

assign out = reg_out;

endmodule

// Tap module
module tap_module(
    input clk,
    input reset,
    input [4:0] in,
    input tap_pos,
    output [4:0] out
);

reg [4:0] reg_out;

always @(posedge clk) begin
    if (reset) begin
        reg_out <= 5'b00000;
    end else begin
        if (tap_pos == 4) begin
            reg_out <= {in[3], in[2], in[1], in[0], in[4] ^ in[0]};
        end else if (tap_pos == 2) begin
            reg_out <= {in[3], in[2] ^ in[0], in[1], in[0], in[4]};
        end else begin
            reg_out <= {in[3:0], in[4]};
        end
    end
end

assign out = reg_out;

endmodule

// Top-level module
module TopModule(
    input clk,
    input reset,
    output [4:0] q
);

wire [4:0] shift_out;
wire [4:0] tap_out1;
wire [4:0] tap_out2;

shift_register shift_reg(
    .clk(clk),
    .reset(reset),
    .in(5'b00001),
    .out(shift_out)
);

tap_module tap1(
    .clk(clk),
    .reset(reset),
    .in(shift_out),
    .tap_pos(2),
    .out(tap_out1)
);

tap_module tap2(
    .clk(clk),
    .reset(reset),
    .in(tap_out1),
    .tap_pos(4),
    .out(tap_out2)
);

assign q = tap_out2;

endmodule