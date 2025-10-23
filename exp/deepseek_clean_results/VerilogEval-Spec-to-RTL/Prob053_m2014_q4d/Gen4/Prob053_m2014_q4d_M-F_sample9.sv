module TopModule (
    input clk,
    input in,
    output out
);

    reg q;
    wire xor_out;
    
    assign xor_out = in ^ q;
    assign out = q;

    always @(posedge clk) begin
        q <= xor_out;
    end

    initial begin
        q = 0;
    end

endmodule