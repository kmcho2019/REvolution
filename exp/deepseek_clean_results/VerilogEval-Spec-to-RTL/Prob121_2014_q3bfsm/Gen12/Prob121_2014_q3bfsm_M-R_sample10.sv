module TopModule (
    input clk,
    input reset,
    input x,
    output z
);

    // One-hot state encoding parameters
    parameter S0 = 5'b00001;
    parameter S1 = 5'b00010;
    parameter S2 = 5'b00100;
    parameter S3 = 5'b01000;
    parameter S4 = 5'b10000;

    reg [4:0] state;
    wire [4:0] next_state;

    // Combinational next-state logic
    assign next_state = 
        (reset) ? S0 :
        (state == S0) ? (x ? S1 : S0) :
        (state == S1) ? (x ? S4 : S1) :
        (state == S2) ? (x ? S1 : S2) :
        (state == S3) ? (x ? S2 : S1) :
        (state == S4) ? (x ? S4 : S3) :
        S0;  // Default case

    // Sequential state update
    always @(posedge clk) begin
        state <= next_state;
    end

    // Output logic remains the same
    assign z = (state == S3) || (state == S4);

endmodule