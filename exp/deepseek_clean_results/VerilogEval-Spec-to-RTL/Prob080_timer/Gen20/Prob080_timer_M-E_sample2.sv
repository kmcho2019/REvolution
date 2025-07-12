module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] counter;
    wire zero_next = (counter == 10'b1);  // Will be zero next cycle if currently 1
    wire hold = ~load & (counter == 0);   // Hold at zero until next load
    
    always @(posedge clk) begin
        if (load)
            counter <= data;
        else if (~hold)
            counter <= counter - 1;
    end

    assign tc = (counter == 0);

endmodule