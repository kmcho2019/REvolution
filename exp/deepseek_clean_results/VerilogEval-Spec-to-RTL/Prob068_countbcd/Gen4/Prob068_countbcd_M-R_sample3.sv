module TopModule (
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [15:0] counter;
    
    // Generate enable signals in parallel
    wire ones_rollover = (counter[3:0] == 4'd9);
    wire tens_rollover = (counter[7:4] == 4'd9);
    wire hundreds_rollover = (counter[11:8] == 4'd9);
    
    assign ena[0] = ones_rollover;
    assign ena[1] = ones_rollover & tens_rollover;
    assign ena[2] = ones_rollover & tens_rollover & hundreds_rollover;
    
    // Combinational next state logic
    wire [15:0] next_counter;
    assign next_counter[3:0] = reset ? 4'd0 : 
                             (counter[3:0] == 4'd9) ? 4'd0 : 
                             counter[3:0] + 4'd1;
                             
    assign next_counter[7:4] = reset ? 4'd0 : 
                             (ena[0] && counter[7:4] == 4'd9) ? 4'd0 : 
                             ena[0] ? counter[7:4] + 4'd1 : 
                             counter[7:4];
                             
    assign next_counter[11:8] = reset ? 4'd0 : 
                              (ena[1] && counter[11:8] == 4'd9) ? 4'd0 : 
                              ena[1] ? counter[11:8] + 4'd1 : 
                              counter[11:8];
                              
    assign next_counter[15:12] = reset ? 4'd0 : 
                               (ena[2] && counter[15:12] == 4'd9) ? 4'd0 : 
                               ena[2] ? counter[15:12] + 4'd1 : 
                               counter[15:12];
    
    // Sequential update
    always @(posedge clk) begin
        counter <= next_counter;
    end
    
    assign q = counter;

endmodule