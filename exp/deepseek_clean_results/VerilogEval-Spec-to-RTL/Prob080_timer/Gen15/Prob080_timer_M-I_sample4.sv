module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] counter;
    wire [9:0] next_counter;
    wire counter_en;
    
    // Clock gating control
    assign counter_en = load || (counter != 0);
    
    // Simplified next counter logic
    assign next_counter = load ? data : 
                        (counter == 0) ? 0 : 
                        {1'b0, counter[9:1]} - {9'b0, counter[0]};
    
    // Gated clock sequential logic
    always @(posedge clk) begin
        if (counter_en) begin
            counter <= next_counter;
        end
    end

    // Terminal count output
    assign tc = (counter == 0);

endmodule