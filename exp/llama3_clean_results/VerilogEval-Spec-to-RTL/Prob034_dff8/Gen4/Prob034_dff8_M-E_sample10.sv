module TopModule #(
    parameter WIDTH = 8
)(
    input clk,
    input [WIDTH-1:0] d,
    output [WIDTH-1:0] q
);

    reg [WIDTH-1:0] q_reg;

    always @(posedge clk) begin
        q_reg <= d;
    end

    assign q = q_reg;

endmodule

// Alternatively, for a more scalable solution using generate:
module TopModuleGen #(
    parameter WIDTH = 8
)(
    input clk,
    input [WIDTH-1:0] d,
    output [WIDTH-1:0] q
);

    reg [WIDTH-1:0] q_reg;

    integer i;
    always @(posedge clk) begin
        for (i = 0; i < WIDTH; i++) begin
            q_reg[i] <= d[i];
        end
    end

    assign q = q_reg;

endmodule

// Using generate for even more explicit instantiation:
module TopModuleGenExplicit #(
    parameter WIDTH = 8
)(
    input clk,
    input [WIDTH-1:0] d,
    output [WIDTH-1:0] q
);

    reg [WIDTH-1:0] q_reg;

    genvar i;
    generate
        for (i = 0; i < WIDTH; i++) begin
            always @(posedge clk) begin
                q_reg[i] <= d[i];
            end
        end
    endgenerate

    assign q = q_reg;

endmodule