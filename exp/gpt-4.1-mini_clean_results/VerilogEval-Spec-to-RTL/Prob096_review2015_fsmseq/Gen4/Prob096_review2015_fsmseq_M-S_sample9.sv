module TopModule (
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

    localparam S0   = 2'd0;  // no match
    localparam S1   = 2'd1;  // matched '1'
    localparam S11  = 2'd2;  // matched '11'
    localparam S110 = 2'd3;  // matched '110'

    reg [1:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            start_shifting <= 1'b0;
        end else begin
            case(state)
                S0:   state <= data ? S1   : S0;
                S1:   state <= data ? S11  : S0;
                S11:  state <= data ? S11  : S110;
                S110: state <= data ? S1   : S0;
                default: state <= S0;
            endcase
            if (state == S110 && data)
                start_shifting <= 1'b1;
        end
    end

endmodule