module BitRevN #(parameter N = 100, parameter PIPELINED = 1) (
    input  wire                 clk,
    input  wire                 rst,
    input  wire [N-1:0]         in,
    output wire [N-1:0]         out
);
    wire [N-1:0] reversed_bits;

    genvar i;
    generate
        for (i = 0; i < N; i = i + 1) begin : bit_reverse
            assign reversed_bits[i] = in[N-1 - i];
        end
    endgenerate

    generate
        if (PIPELINED) begin : pipelined_out
            reg [N-1:0] out_reg;
            always @(posedge clk or posedge rst) begin
                if (rst)
                    out_reg <= {N{1'b0}};
                else
                    out_reg <= reversed_bits;
            end
            assign out = out_reg;
        end else begin : direct_out
            assign out = reversed_bits;
        end
    endgenerate
endmodule

module TopModule (
    input  wire        clk,
    input  wire        rst,
    input  wire [99:0] in,
    output wire [99:0] out
);
    // Instantiate BitRevN with pipeline enabled for better timing on wide data
    BitRevN #(100, 1) bitrev_inst (
        .clk(clk),
        .rst(rst),
        .in(in),
        .out(out)
    );
endmodule