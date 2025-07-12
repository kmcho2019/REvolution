module TopModule(
    input clk,
    input [7:0] d,
    output [7:0] q
);

    // 8 D flip-flops in parallel
    reg [7:0] q;

    always @(posedge clk)
    begin
        q <= d;
    end

    // or using DFF instances
    // DFF dff0(.clk(clk), .d(d[0]), .q(q[0]));
    // DFF dff1(.clk(clk), .d(d[1]), .q(q[1]));
    // DFF dff2(.clk(clk), .d(d[2]), .q(q[2]));
    // DFF dff3(.clk(clk), .d(d[3]), .q(q[3]));
    // DFF dff4(.clk(clk), .d(d[4]), .q(q[4]));
    // DFF dff5(.clk(clk), .d(d[5]), .q(q[5]));
    // DFF dff6(.clk(clk), .d(d[6]), .q(q[6]));
    // DFF dff7(.clk(clk), .d(d[7]), .q(q[7]));

    // But the above is not a built-in Verilog DFF, so we use always block to create one
    // or we could use a generate block to instantiate 8 of the same DFF

    // using generate block
    // genvar i;
    // generate
    //     for (i = 0; i < 8; i = i + 1)
    //     begin: dff_array
    //         DFF dff(.clk(clk), .d(d[i]), .q(q[i]));
    //     end
    // endgenerate

endmodule

// But the above requires a DFF module definition
// Here is a simple DFF module
module DFF(
    input clk,
    input d,
    output reg q
);

    always @(posedge clk)
    begin
        q <= d;
    end

endmodule