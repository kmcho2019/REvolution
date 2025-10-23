module TopModule (
    input clk,
    input in,
    output out
);

    reg state;
    wire xor_out = in ^ state;
    
    always @(posedge clk) begin
        state <= xor_out;
    end
    
    assign out = state;

endmodule