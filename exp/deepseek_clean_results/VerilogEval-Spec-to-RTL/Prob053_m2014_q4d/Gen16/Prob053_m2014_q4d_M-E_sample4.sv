module TopModule (
    input clk,
    input in,
    output out
);

    wire feedback;
    wire xor_out = in ^ feedback;
    
    // Clock-gated buffer for edge-triggered behavior
    reg state;
    always @(clk) begin
        if (clk) begin
            state <= xor_out;
        end
    end
    
    assign feedback = state;
    assign out = state;

endmodule