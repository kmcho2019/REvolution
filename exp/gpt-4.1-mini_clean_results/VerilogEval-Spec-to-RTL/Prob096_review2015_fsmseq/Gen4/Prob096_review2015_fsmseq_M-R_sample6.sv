module TopModule (
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

    // One-hot state encoding
    localparam S0    = 4'b0001; // no match
    localparam S1    = 4'b0010; // matched '1'
    localparam S11   = 4'b0100; // matched '11'
    localparam S110  = 4'b1000; // matched '110'

    reg [3:0] state;
    wire [3:0] next_state;

    // Next state logic using combinational assign
    assign next_state = (state == S0)   ? (data ? S1    : S0)   :
                        (state == S1)   ? (data ? S11   : S0)   :
                        (state == S11)  ? (data ? S11   : S110) :
                        (state == S110) ? (data ? S1    : S0)   :
                        S0;

    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            start_shifting <= 1'b0;
        end else begin
            state <= next_state;
            // Set start_shifting when full sequence 1101 detected (state S110 + data=1)
            if (state == S110 && data)
                start_shifting <= 1'b1;
        end
    end

endmodule