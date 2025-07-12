module TopModule (
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

    // Current and previous input states
    reg [7:0] curr_in;
    reg [7:0] prev_in;
    
    always @(posedge clk) begin
        prev_in <= curr_in;  // Store previous state
        curr_in <= in;       // Store current state
    end
    
    // Positive edge detection: 
    // Transition from 0 (prev_in) to 1 (curr_in)
    assign pedge = ~prev_in & curr_in;

endmodule