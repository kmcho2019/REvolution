module TopModule (
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [15:0] counter;
    
    // Enable signals
    assign ena[0] = (counter[3:0] == 4'd9);
    assign ena[1] = (counter[7:4] == 4'd9) && ena[0];
    assign ena[2] = (counter[11:8] == 4'd9) && ena[1];
    
    assign q = counter;
    
    // Next counter value computation
    wire [15:0] next_counter;
    assign next_counter = reset ? 16'd0 : {
        // Thousands digit
        (ena[2] ? 
            (counter[15:12] == 4'd9 ? 4'd0 : counter[15:12] + 4'd1) : 
            counter[15:12]),
        // Hundreds digit
        (ena[1] ? 
            (counter[11:8] == 4'd9 ? 4'd0 : counter[11:8] + 4'd1) : 
            counter[11:8]),
        // Tens digit
        (ena[0] ? 
            (counter[7:4] == 4'd9 ? 4'd0 : counter[7:4] + 4'd1) : 
            counter[7:4]),
        // Ones digit
        (counter[3:0] == 4'd9 ? 4'd0 : counter[3:0] + 4'd1)
    };
    
    always @(posedge clk) begin
        counter <= next_counter;
    end

endmodule