module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] counter;
    wire [9:0] next_counter;
    wire [3:0] leading_one_pos;
    wire near_zero = (counter[9:1] == 9'b0); // Only need to check upper bits
    
    // Priority encoder to find leading '1' (simplified for this use case)
    assign leading_one_pos = 
        counter[9] ? 4'd9 :
        counter[8] ? 4'd8 :
        counter[7] ? 4'd7 :
        counter[6] ? 4'd6 :
        counter[5] ? 4'd5 :
        counter[4] ? 4'd4 :
        counter[3] ? 4'd3 :
        counter[2] ? 4'd2 :
        counter[1] ? 4'd1 : 4'd0;
    
    // Next counter value logic with early termination
    assign next_counter = load ? data : 
                        near_zero ? 10'b0 : 
                        counter - (1'b1 << leading_one_pos);

    // D flip-flop implementation
    always @(posedge clk) begin
        counter <= next_counter;
    end

    // Terminal count output
    assign tc = (counter == 0);

endmodule