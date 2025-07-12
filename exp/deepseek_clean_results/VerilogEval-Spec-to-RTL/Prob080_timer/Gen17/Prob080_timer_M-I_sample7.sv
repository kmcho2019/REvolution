module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] counter;
    wire [9:0] next_counter;
    wire counter_enable;
    
    // Clock gating: only enable counter update when needed
    assign counter_enable = load || (counter != 0);
    
    // Optimized next counter logic
    assign next_counter = load ? data : 
                        (counter == 0) ? 0 : 
                        counter - 1;

    // Sequential logic with clock gating
    always @(posedge clk) begin
        if (counter_enable) begin
            counter <= next_counter;
        end
    end

    // Terminal count output
    assign tc = (counter == 0);

endmodule