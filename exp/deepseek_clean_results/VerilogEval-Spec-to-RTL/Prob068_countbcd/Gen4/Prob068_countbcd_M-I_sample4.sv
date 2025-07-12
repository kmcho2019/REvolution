module TopModule (
    input clk,
    input reset,
    output reg [2:0] ena,
    output reg [15:0] q
);

    // Overflow flags for each digit
    wire ones_ovf = (q[3:0] == 4'd9);
    wire tens_ovf = (q[7:4] == 4'd9);
    wire hundreds_ovf = (q[11:8] == 4'd9);
    
    // Next value calculation
    wire [15:0] next_q;
    assign next_q[3:0] = reset ? 4'd0 : (ones_ovf ? 4'd0 : q[3:0] + 4'd1);
    assign next_q[7:4] = reset ? 4'd0 : 
                        (ones_ovf ? (tens_ovf ? 4'd0 : q[7:4] + 4'd1) : q[7:4]);
    assign next_q[11:8] = reset ? 4'd0 : 
                         (ones_ovf & tens_ovf ? (hundreds_ovf ? 4'd0 : q[11:8] + 4'd1) : q[11:8]);
    assign next_q[15:12] = reset ? 4'd0 : 
                          (ones_ovf & tens_ovf & hundreds_ovf ? 
                          (q[15:12] == 4'd9 ? 4'd0 : q[15:12] + 4'd1) : q[15:12]);

    always @(posedge clk) begin
        q <= next_q;
        
        // Registered enable signals
        ena[0] <= ones_ovf;
        ena[1] <= ones_ovf & tens_ovf;
        ena[2] <= ones_ovf & tens_ovf & hundreds_ovf;
    end

endmodule