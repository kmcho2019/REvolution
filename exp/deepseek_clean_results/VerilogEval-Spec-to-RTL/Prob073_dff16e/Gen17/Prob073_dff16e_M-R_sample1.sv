module ByteRegister #(
    parameter WIDTH = 8
) (
    input clk,
    input resetn,
    input enable,
    input [WIDTH-1:0] d,
    output [WIDTH-1:0] q
);
    // Next state logic
    wire [WIDTH-1:0] next_q = !resetn ? {WIDTH{1'b0}} : 
                             enable ? d : q;
    
    // DFF array
    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : dff_array
            DFF dff_inst (
                .clk(clk),
                .d(next_q[i]),
                .q(q[i])
            );
        end
    endgenerate
endmodule

module DFF (
    input clk,
    input d,
    output reg q
);
    always @(posedge clk) begin
        q <= d;
    end
endmodule

module TopModule (
    input clk,
    input resetn,
    input [1:0] byteena,
    input [15:0] d,
    output [15:0] q
);

    // Instantiate two byte registers
    ByteRegister upper_byte (
        .clk(clk),
        .resetn(resetn),
        .enable(byteena[1]),
        .d(d[15:8]),
        .q(q[15:8])
    );

    ByteRegister lower_byte (
        .clk(clk),
        .resetn(resetn),
        .enable(byteena[0]),
        .d(d[7:0]),
        .q(q[7:0])
    );

endmodule