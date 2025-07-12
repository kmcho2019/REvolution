module TopModule (
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [15:0] counter;
    wire [15:0] next_counter;
    
    assign q = counter;
    
    // Next state computation
    assign next_counter = reset ? 16'd0 : 
        (counter[3:0] == 4'd9 ? 
            (counter[7:4] == 4'd9 ?
                (counter[11:8] == 4'd9 ?
                    (counter[15:12] == 4'd9 ? 16'd0 :
                    {counter[15:12] + 4'd1, 12'd0}) :
                    {counter[15:8], counter[11:8] + 4'd1, 8'd0}) :
                {counter[15:4], counter[7:4] + 4'd1, 4'd0}) :
            counter + 16'd1);
    
    // Enable signals based on digit transitions
    assign ena[0] = (counter[3:0] == 4'd9);  // tens enable
    assign ena[1] = (counter[3:0] == 4'd9) && (counter[7:4] == 4'd9);  // hundreds enable
    assign ena[2] = (counter[3:0] == 4'd9) && (counter[7:4] == 4'd9) && (counter[11:8] == 4'd9);  // thousands enable
    
    always @(posedge clk) begin
        counter <= next_counter;
    end

endmodule