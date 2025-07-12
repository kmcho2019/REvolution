module TopModule (
    input clk,
    input in,
    output out
);

    reg tff_out;
    wire d_input;
    
    // T flip-flop implementation:
    // D input is current output XORed with T input (in)
    assign d_input = tff_out ^ in;
    
    // Positive edge-triggered flip-flop
    always @(posedge clk) begin
        tff_out <= d_input;
    end
    
    // Connect output
    assign out = tff_out;

endmodule