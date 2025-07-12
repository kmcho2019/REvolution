module TopModule (
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

    // One-hot encoded states
    reg [6:0] state;
    localparam S0 = 7'b0000001;  // Initial state (0 ones)
    localparam S1 = 7'b0000010;  // 1 one
    localparam S2 = 7'b0000100;  // 2 ones
    localparam S3 = 7'b0001000;  // 3 ones
    localparam S4 = 7'b0010000;  // 4 ones
    localparam S5 = 7'b0100000;  // 5 ones
    localparam S6 = 7'b1000000;  // 6 ones

    // State transitions
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
        end else begin
            case (state)
                S0: state <= in ? S1 : S0;
                S1: state <= in ? S2 : S0;
                S2: state <= in ? S3 : S0;
                S3: state <= in ? S4 : S0;
                S4: state <= in ? S5 : S0;
                S5: state <= in ? S6 : S0;
                S6: state <= in ? S6 : S0;  // Stay in S6 if more 1s come
                default: state <= S0;
            endcase
        end
    end

    // Output logic (combinational)
    assign disc = (state == S5) & ~in;
    assign flag = (state == S6) & ~in;
    assign err  = (state == S6) & in;

endmodule