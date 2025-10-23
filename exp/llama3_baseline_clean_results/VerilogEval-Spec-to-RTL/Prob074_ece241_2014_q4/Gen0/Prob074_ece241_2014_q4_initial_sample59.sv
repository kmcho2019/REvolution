module TopModule(clk, x, z);
    input clk;
    input x;
    output z;
    reg [2:0] ff_out;
    wire [2:0] ff_in;

    always @(posedge clk) begin
        ff_out[0] <= ff_in[0];
        ff_out[1] <= ff_in[1];
        ff_out[2] <= ff_in[2];
    end

    assign ff_in[0] = x ^ ff_out[0];
    assign ff_in[1] = x & ~ff_out[1];
    assign ff_in[2] = x | ~ff_out[2];

    assign z = ~(ff_out[0] | ff_out[1] | ff_out[2]);
endmodule