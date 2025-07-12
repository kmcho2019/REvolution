module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] counter;
    wire counter_zero = ~counter[9]; // Simplified zero detection (MSB=0 when counter=0)
    wire clk_en = ~counter_zero || load; // Clock gating when idle
    wire [9:0] next_counter;
    
    // Separate load and decrement logic
    assign next_counter = load ? data : 
                        counter_zero ? 10'b0 : 
                        counter - 1;
    
    assign tc = counter_zero;
    
    always @(posedge clk) begin
        if (clk_en) begin
            counter <= next_counter;
        end
    end

endmodule