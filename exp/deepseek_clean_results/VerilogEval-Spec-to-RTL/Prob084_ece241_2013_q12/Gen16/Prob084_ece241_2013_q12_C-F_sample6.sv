module ShiftRegister #(parameter WIDTH = 8) (
    input clk,
    input enable,
    input S,
    output reg [WIDTH-1:0] Q
);
    always @(posedge clk) begin
        if (enable) begin
            Q <= {Q[WIDTH-2:0], S};  // MSB-first shifting
        end
    end
endmodule

module Mux8to1 (
    input [7:0] data,
    input [2:0] sel,
    output out
);
    assign out = data[sel];  // Direct indexing for optimal performance
endmodule

module TopModule (
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output Z
);
    localparam MEM_WIDTH = 8;
    wire [MEM_WIDTH-1:0] mem_out;
    wire [2:0] addr = {A, B, C};

    ShiftRegister #(.WIDTH(MEM_WIDTH)) memory (
        .clk(clk),
        .enable(enable),
        .S(S),
        .Q(mem_out)
    );

    Mux8to1 output_mux (
        .data(mem_out),
        .sel(addr),
        .out(Z)
    );
endmodule