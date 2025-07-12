module TopModule (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    // State encoding
    parameter S0 = 3'd0, S1 = 3'd1, S2 = 3'd2, S3 = 3'd3,
              S4 = 3'd4, S5 = 3'd5, S6 = 3'd6, S7 = 3'd7;

    reg [2:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            {disc, flag, err} <= 3'b0;
        end else begin
            // State transitions
            case (state)
                S0: state <= in ? S1 : S0;
                S1: state <= in ? S2 : S0;
                S2: state <= in ? S3 : S0;
                S3: state <= in ? S4 : S0;
                S4: state <= in ? S5 : S0;
                S5: state <= in ? S6 : S0;
                S6: state <= in ? S7 : S0;
                S7: state <= in ? S7 : S0;
            endcase

            // Output generation
            disc <= (state == S5) && !in;
            flag <= (state == S6) && !in;
            err <= (state == S6 && in) || (state == S7);
        end
    end

endmodule