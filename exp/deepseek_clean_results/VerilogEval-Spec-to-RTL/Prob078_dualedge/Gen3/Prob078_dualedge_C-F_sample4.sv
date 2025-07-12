module TopModule (
    input clk,
    input d,
    output reg q
);

    reg q_pos, q_neg;
    wire q_mux;
    
    // Positive edge triggered flip-flop
    always @(posedge clk) begin
        q_pos <= d;
    end
    
    // Negative edge triggered flip-flop
    always @(negedge clk) begin
        q_neg <= d;
    end
    
    // Combinational output selection
    assign q_mux = clk ? q_pos : q_neg;
    
    // Registered output for better timing
    always @(posedge clk) begin
        q <= q_mux;
    end

endmodule