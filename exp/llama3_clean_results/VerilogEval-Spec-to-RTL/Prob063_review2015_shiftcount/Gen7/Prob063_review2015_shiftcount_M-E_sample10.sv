module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output [3:0] q
);

// Register module
module Register (
    input clk,
    input [3:0] data_in,
    output [3:0] q
);
reg [3:0] q_reg;
always @(posedge clk) begin
    q_reg <= data_in;
end
assign q = q_reg;
endmodule

// Shift module
module Shift (
    input [3:0] data_in,
    input data,
    output [3:0] q
);
assign q = {data, data_in[3:1]};
endmodule

// Count module
module Count (
    input [3:0] data_in,
    output [3:0] q
);
assign q = (data_in == 4'b0000) ? 4'b1111 : data_in - 1;
endmodule

// FSM module
module FSM (
    input clk,
    input shift_ena,
    input count_ena,
    output shift_sel,
    output count_sel
);
reg shift_sel_reg;
reg count_sel_reg;
always @(posedge clk) begin
    if (shift_ena) begin
        shift_sel_reg <= 1'b1;
        count_sel_reg <= 1'b0;
    end else if (count_ena) begin
        shift_sel_reg <= 1'b0;
        count_sel_reg <= 1'b1;
    end else begin
        shift_sel_reg <= 1'b0;
        count_sel_reg <= 1'b0;
    end
end
assign shift_sel = shift_sel_reg;
assign count_sel = count_sel_reg;
endmodule

// Instantiate modules
wire [3:0] shift_out;
wire [3:0] count_out;
wire shift_sel;
wire count_sel;

Register reg_module (
    .clk(clk),
    .data_in(shift_sel ? shift_out : (count_sel ? count_out : q)),
    .q(q)
);

Shift shift_module (
    .data_in(q),
    .data(data),
    .q(shift_out)
);

Count count_module (
    .data_in(q),
    .q(count_out)
);

FSM fsm_module (
    .clk(clk),
    .shift_ena(shift_ena),
    .count_ena(count_ena),
    .shift_sel(shift_sel),
    .count_sel(count_sel)
);

endmodule