module TopModule(
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

    // One-hot style state encoding
    localparam S0   = 4'b0001;
    localparam S1   = 4'b0010;
    localparam S11  = 4'b0100;
    localparam S110 = 4'b1000;

    reg [3:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            start_shifting <= 1'b0;
        end else begin
            // Default: hold state
            case (state)
                S0:   state <= data ? S1 : S0;
                S1:   state <= data ? S11 : S0;
                S11:  state <= data ? S11 : S110;
                S110: state <= data ? S1 : S0;
                default: state <= S0;
            endcase

            // Set start_shifting when sequence 1101 detected (S110 + data=1)
            if (state == S110 && data == 1'b1)
                start_shifting <= 1'b1;
            else if (start_shifting)
                start_shifting <= 1'b1; // latch high forever until reset
            else
                start_shifting <= 1'b0;
        end
    end

endmodule