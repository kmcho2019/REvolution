module TopModule (
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

    // One-hot state encoding
    reg [4:0] state;
    localparam S0     = 5'b00001;
    localparam S1     = 5'b00010;
    localparam S2     = 5'b00100;
    localparam S3     = 5'b01000;
    localparam S4     = 5'b10000;
    localparam S_ERR  = 5'b10000; // Shared with S4

    // State transitions
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
        end else begin
            case (1'b1) // synthesis parallel_case
                state[0]: state <= in ? S1 : S0;       // S0
                state[1]: state <= in ? S2 : S0;       // S1
                state[2]: state <= in ? S3 : S0;       // S2
                state[3]: state <= in ? S4 : S0;       // S3
                state[4]: state <= in ? S_ERR : S0;    // S4/S_ERR
                default: state <= S0;
            endcase
        end
    end

    // Output logic - combinational
    assign disc = (state == S4) && !in;
    assign flag = (state == S4) && !in && !reset;
    assign err  = (state == S_ERR) && in;

endmodule