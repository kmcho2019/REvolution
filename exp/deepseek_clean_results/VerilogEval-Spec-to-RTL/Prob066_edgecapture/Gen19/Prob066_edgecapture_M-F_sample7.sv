module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

    reg [31:0] prev_in;  // stores input from previous cycle
    reg [31:0] out_reg;  // holds detected falling edges
    
    assign out = out_reg;

    always @(posedge clk) begin
        if (reset) begin
            prev_in <= 32'b0;
            out_reg <= 32'b0;
        end else begin
            // Detect falling edges (1->0 transitions)
            // Once a bit is set in out_reg, it remains set until reset
            out_reg <= out_reg | (prev_in & ~in);
            prev_in <= in;
        end
    end

    // Debug assertions (optional)
    // synthesis translate_off
    always @(posedge clk) begin
        if (!reset) begin
            // Verify edge detection timing
            for (integer i=0; i<32; i=i+1) begin
                if (prev_in[i] && !in[i]) begin
                    $display("Falling edge detected on bit %0d at time %0t", i, $time);
                end
            end
        end
    end
    // synthesis translate_on

endmodule