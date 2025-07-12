module TopModule (
    input clk,
    input in,
    output out
);

    wire d_input;
    reg q_out;
    
    assign d_input = in ^ q_out;
    assign out = q_out;
    
    always @(posedge clk) begin
        q_out <= d_input;
    end

endmodule