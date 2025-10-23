module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] counter;
    wire [9:0] next_counter;
    wire counter_zero = ~|counter;  // OR reduction for zero detection
    
    // Next counter value logic with load priority
    assign next_counter = load ? data : 
                         counter_zero ? 0 : 
                         counter - 1;

    // Clock gating when counter is zero and not loading
    wire clk_en = ~counter_zero || load;
    
    // D flip-flop implementation with clock gating
    always @(posedge clk) begin
        if (clk_en) begin
            counter <= next_counter;
        end
    end

    // Terminal count output
    assign tc = counter_zero;

endmodule