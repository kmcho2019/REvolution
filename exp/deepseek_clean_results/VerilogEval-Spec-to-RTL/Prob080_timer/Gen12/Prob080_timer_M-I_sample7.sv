module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output reg tc
);

    reg [9:0] counter;
    wire counter_enable = (counter != 0) && !load;
    
    always @(posedge clk) begin
        if (load) begin
            counter <= data;
        end
        else if (counter_enable) begin
            counter <= counter - 1;
        end
        
        tc <= (counter == 0);
    end

endmodule