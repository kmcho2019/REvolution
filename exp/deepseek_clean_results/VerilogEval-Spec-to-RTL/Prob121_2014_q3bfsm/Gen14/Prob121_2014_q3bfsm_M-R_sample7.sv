module TopModule (
    input clk,
    input reset,
    input x,
    output z
);

    // One-hot encoded states for potentially better timing
    parameter [4:0] S0 = 5'b00001,
                    S1 = 5'b00010,
                    S2 = 5'b00100,
                    S3 = 5'b01000,
                    S4 = 5'b10000;

    reg [4:0] state, next_state;

    // Combinational next-state logic
    assign next_state = reset ? S0 : 
                       (state == S0) ? (x ? S1 : S0) :
                       (state == S1) ? (x ? S4 : S1) :
                       (state == S2) ? (x ? S1 : S2) :
                       (state == S3) ? (x ? S2 : S1) :
                       (state == S4) ? (x ? S4 : S3) :
                       S0;  // default case

    // Sequential state register
    always @(posedge clk) begin
        state <= next_state;
    end

    // Output logic - explicit about which states produce z=1
    assign z = (state == S3) || (state == S4);

endmodule