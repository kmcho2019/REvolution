module TopModule (
    input clk,
    input reset,
    input x,
    output z
);

    // State counter (0-4 represents states 000-100)
    reg [2:0] state_count;

    // Next state calculation
    wire [2:0] next_count;
    assign next_count = 
        (state_count == 0) ? (x ? 1 : 0) :  // S0
        (state_count == 1) ? (x ? 4 : 1) :  // S1
        (state_count == 2) ? (x ? 1 : 2) :  // S2
        (state_count == 3) ? (x ? 2 : 1) :  // S3
        (state_count == 4) ? (x ? 4 : 3) :  // S4
        0;  // default to S0

    // Output is high when count is 3 or 4 (states 011 or 100)
    assign z = (state_count == 3) | (state_count == 4);

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state_count <= 0;
        else
            state_count <= next_count;
    end

endmodule