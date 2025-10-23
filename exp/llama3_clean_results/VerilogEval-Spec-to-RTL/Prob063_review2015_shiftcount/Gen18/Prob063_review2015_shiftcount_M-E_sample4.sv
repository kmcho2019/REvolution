module TopModule(
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output [3:0] q
);

// Internal wire to connect the output of the shift module to the multiplexer
wire [3:0] shift_out;

// Internal wire to connect the output of the count module to the multiplexer
wire [3:0] count_out;

// Shift register module
module ShiftModule(
    input clk,
    input ena,
    input [3:0] data,
    output [3:0] q
);
    reg [3:0] q_reg;
    always @(posedge clk) begin
        if (ena) begin
            q_reg <= {q_reg[2:0], data[3]};
        end
    end
    assign q = q_reg;
endmodule

// Instantiation of the ShiftModule
ShiftModule shift_module(
   .clk(clk),
   .ena(shift_ena),
   .data({data, 3'b000}), // Extending data to match the 4-bit width
   .q(shift_out)
);

// Down counter module
module CountModule(
    input clk,
    input ena,
    output [3:0] q
);
    reg [3:0] q_reg;
    always @(posedge clk) begin
        if (ena) begin
            q_reg <= q_reg - 1;
        end
    end
    assign q = q_reg;
endmodule

// Instantiation of the CountModule
CountModule count_module(
   .clk(clk),
   .ena(count_ena),
   .q(count_out)
);

// Continuous assignment to select between shift_out and count_out based on enable signals
assign q = (shift_ena)? shift_out : count_out;

endmodule