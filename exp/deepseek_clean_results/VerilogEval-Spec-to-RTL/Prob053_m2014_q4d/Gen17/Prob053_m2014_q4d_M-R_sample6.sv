module TopModule (
    input clk,
    input in,
    output out
);

    wire d_ff_input;
    reg delayed_out;
    
    assign d_ff_input = in ^ delayed_out;
    assign out = delayed_out;
    
    always @(posedge clk) begin
        delayed_out <= d_ff_input;
    end

endmodule