module TopModule (
    input clk,
    input reset,
    input x,
    output z
);

    // One-hot state encoding
    localparam S0 = 5'b00001;
    localparam S1 = 5'b00010;
    localparam S2 = 5'b00100;
    localparam S3 = 5'b01000;
    localparam S4 = 5'b10000;

    reg [4:0] state;

    // Next state logic as continuous assignments
    wire [4:0] next_state;
    assign next_state = 
        (state == S0) ? (x ? S1 : S0) :
        (state == S1) ? (x ? S4 : S1) :
        (state == S2) ? (x ? S1 : S2) :
        (state == S3) ? (x ? S2 : S1) :
        (state == S4) ? (x ? S4 : S3) :
        S0;  // Default to S0

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

    // Output logic - z=1 when in S3 or S4
    assign z = (state == S3) | (state == S4);

endmodule