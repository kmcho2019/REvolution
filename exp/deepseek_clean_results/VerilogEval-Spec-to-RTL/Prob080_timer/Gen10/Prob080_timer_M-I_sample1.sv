module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output reg tc
);

    reg [9:0] counter;
    wire clk_enable = ~tc | load;  // Clock gating when not zero or loading

    always @(posedge clk) begin
        if (load) begin
            counter <= data;
            tc <= 1'b0;
        end
        else if (clk_enable) begin
            // Pipelined decrement: upper and lower 5 bits separately
            if (counter[4:0] != 5'b0)
                counter[4:0] <= counter[4:0] - 1;
            else begin
                counter[4:0] <= 5'b11111;
                if (counter[9:5] != 5'b0)
                    counter[9:5] <= counter[9:5] - 1;
            end
            
            // Update tc one cycle after counter reaches zero
            tc <= (counter == 10'b1);  // Will be zero next cycle
        end
    end

endmodule