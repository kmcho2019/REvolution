module DFF (
    input clk,
    input resetn,
    input d,
    output reg q
);
    // Synchronous active-low reset DFF with non-blocking assignment
    always @(posedge clk) begin
        if (~resetn)
            q <= 1'b0;
        else
            q <= d;
    end
endmodule

module ShiftReg #(
    parameter WIDTH = 4
) (
    input  clk,
    input  resetn,
    input  in,
    output out
);
    reg [WIDTH-1:0] shift_reg;
    wire [WIDTH-1:0] q;  // internal wires to expose bits

    always @(posedge clk) begin
        if (~resetn)
            shift_reg <= {WIDTH{1'b0}};
        else
            shift_reg <= {shift_reg[WIDTH-2:0], in};
    end

    assign q = shift_reg; // expose internal bits as wires

    assign out = q[WIDTH-1];
endmodule

module TopModule (
    input  clk,
    input  resetn,
    input  in,
    output out
);
    ShiftReg #(.WIDTH(4)) shift_reg_inst (
        .clk(clk),
        .resetn(resetn),
        .in(in),
        .out(out)
    );
endmodule