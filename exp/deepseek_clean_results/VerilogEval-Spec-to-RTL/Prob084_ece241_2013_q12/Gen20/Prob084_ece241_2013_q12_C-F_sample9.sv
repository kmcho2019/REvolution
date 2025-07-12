module ShiftRegister #(
    parameter WIDTH = 8
) (
    input clk,
    input enable,
    input S,
    output reg [WIDTH-1:0] Q
);
    always @(posedge clk) begin
        if (enable) begin
            Q <= {Q[WIDTH-2:0], S};  // MSB first shift
        end
    end
endmodule

module MuxNto1 #(
    parameter WIDTH = 8,
    parameter SEL_WIDTH = $clog2(WIDTH)
) (
    input [WIDTH-1:0] data,
    input [SEL_WIDTH-1:0] sel,
    output reg out
);
    always @(*) begin
        out = data[sel];  // Direct indexing for optimal performance
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
    localparam WIDTH = 8;
    localparam SEL_WIDTH = 3;
    
    wire [WIDTH-1:0] Q;
    wire [SEL_WIDTH-1:0] sel = {A, B, C};

    ShiftRegister #(
        .WIDTH(WIDTH)
    ) sr (
        .clk(clk),
        .enable(enable),
        .S(S),
        .Q(Q)
    );

    MuxNto1 #(
        .WIDTH(WIDTH),
        .SEL_WIDTH(SEL_WIDTH)
    ) mux (
        .data(Q),
        .sel(sel),
        .out(Z)
    );
endmodule