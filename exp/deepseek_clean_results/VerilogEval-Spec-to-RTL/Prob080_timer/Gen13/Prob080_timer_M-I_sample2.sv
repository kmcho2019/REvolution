module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output reg tc
);

    reg [9:0] counter;
    wire counter_zero = (counter == 10'b0);
    wire gated_clk = clk & (~counter_zero | load);
    
    always @(posedge gated_clk) begin
        if (load) begin
            counter <= data;
            tc <= 1'b0;
        end
        else if (!counter_zero) begin
            counter <= counter - 1'b1;
            tc <= (counter == 10'b1);  // Will be zero next cycle
        end
    end

    // Additional register for tc to meet timing
    always @(posedge clk) begin
        if (load)
            tc <= 1'b0;
        else if (counter == 10'b1)
            tc <= 1'b1;
    end

endmodule