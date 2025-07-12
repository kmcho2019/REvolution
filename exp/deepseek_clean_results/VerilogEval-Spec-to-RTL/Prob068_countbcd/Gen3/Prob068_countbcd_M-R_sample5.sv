module TopModule (
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [15:0] counter;

    // Combinational enable signals
    assign ena[0] = (counter[3:0] == 4'd9);
    assign ena[1] = (counter[7:0] == 8'h99);
    assign ena[2] = (counter[11:0] == 12'h999);

    // Combinational next state logic
    wire [15:0] next_counter;
    assign next_counter = reset ? 16'd0 : 
        (counter == 16'h9999) ? 16'd0 :  // Full rollover
        counter + 
        (counter[3:0] == 4'd9 ? 16'h7 :  // +1-9 = -8+16 = +7
        (counter[7:0] == 8'h99 ? 16'h67 : // +1-99 = -98+160 = +62
        (counter[11:0] == 12'h999 ? 16'h667 : // +1-999 = -998+1024 = +26
        16'h1;  // Simple increment

    // Output assignment
    assign q = counter;

    // Sequential update
    always @(posedge clk) begin
        counter <= next_counter;
    end

endmodule