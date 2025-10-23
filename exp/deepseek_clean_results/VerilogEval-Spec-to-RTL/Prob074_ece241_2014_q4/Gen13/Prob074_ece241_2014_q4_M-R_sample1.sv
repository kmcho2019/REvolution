module TopModule (
    input clk,
    input x,
    output z
);

    // Flip-flop outputs
    reg xor_ff, and_ff, or_ff;
    
    // Asynchronous active-low reset (initializes flip-flops to 0)
    wire rst_n = 0;  // Tied low for constant reset condition as per problem requirements
    
    // Combinational logic
    wire xor_in = x ^ xor_ff;
    wire and_in = x & ~and_ff;
    wire or_in = x | ~or_ff;
    
    // Sequential logic with asynchronous reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            xor_ff <= 1'b0;
            and_ff <= 1'b0;
            or_ff  <= 1'b0;
        end else begin
            xor_ff <= xor_in;
            and_ff <= and_in;
            or_ff  <= or_in;
        end
    end
    
    // Output logic
    assign z = ~(xor_ff | and_ff | or_ff);

endmodule