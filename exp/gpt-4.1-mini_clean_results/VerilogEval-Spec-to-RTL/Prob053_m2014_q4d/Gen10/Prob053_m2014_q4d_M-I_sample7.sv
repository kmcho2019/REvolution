module DFF (
    input clk,
    input d,
    output reg q
);
    // Initialize q to 0 to avoid unknown initial state in simulation
    initial begin
        q = 1'b0;
    end

    always @(posedge clk) begin
        q <= d;
    end
endmodule

module TopModule (
    input clk,
    input in,
    output out
);
    wire xor_out;
    wire dff_out;

    assign xor_out = in ^ dff_out;

    DFF dff_inst (
        .clk(clk),
        .d(xor_out),
        .q(dff_out)
    );

    assign out = dff_out;

endmodule