module ShiftRegister8 (
    input clk,
    input enable,
    input S,
    output reg [7:0] Q
);
    always @(posedge clk) begin
        if (enable) begin
            Q <= {Q[6:0], S};  // Efficient vector shift operation
        end
    end
endmodule

module Mux8 (
    input [7:0] data,
    input [2:0] sel,
    output reg out
);
    always @(*) begin
        out = data[sel];  // Optimal direct indexing
    end
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
    wire [7:0] reg_out;
    wire [2:0] select = {A, B, C};

    ShiftRegister8 sr_inst (
        .clk(clk),
        .enable(enable),
        .S(S),
        .Q(reg_out)
    );

    Mux8 mux_inst (
        .data(reg_out),
        .sel(select),
        .out(Z)
    );
endmodule