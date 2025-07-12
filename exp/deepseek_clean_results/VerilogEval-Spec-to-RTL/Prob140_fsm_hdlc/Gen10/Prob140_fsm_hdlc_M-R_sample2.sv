module TopModule (
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

    // One-hot state encoding
    parameter S0 = 8'b00000001;
    parameter S1 = 8'b00000010;
    parameter S2 = 8'b00000100;
    parameter S3 = 8'b00001000;
    parameter S4 = 8'b00010000;
    parameter S5 = 8'b00100000;
    parameter S6 = 8'b01000000;
    parameter S7 = 8'b10000000;

    reg [7:0] state;

    // Next state logic
    wire [7:0] next_state;
    assign next_state = reset ? S0 :
                      in ? (state == S0) ? S1 :
                           (state == S1) ? S2 :
                           (state == S2) ? S3 :
                           (state == S3) ? S4 :
                           (state == S4) ? S5 :
                           (state == S5) ? S6 :
                           (state == S6) ? S7 :
                           S7 : // state == S7
                      S0; // in == 0

    // State register
    always @(posedge clk) begin
        state <= next_state;
    end

    // Output logic
    assign disc = (state == S5) && !in;
    assign flag = (state == S6) && !in;
    assign err  = (state >= S6) && in;

endmodule