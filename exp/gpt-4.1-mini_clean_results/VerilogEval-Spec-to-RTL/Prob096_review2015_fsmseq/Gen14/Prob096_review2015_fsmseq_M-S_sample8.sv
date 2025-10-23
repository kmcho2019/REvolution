module TopModule (
    input  clk,
    input  reset,
    input  data,
    output start_shifting
);

    // Binary encoded states
    localparam S0 = 3'd0; // no match
    localparam S1 = 3'd1; // matched '1'
    localparam S2 = 3'd2; // matched '11'
    localparam S3 = 3'd3; // matched '110'
    localparam S4 = 3'd4; // matched '1101' final sticky

    reg [2:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
        end else begin
            case (state)
                S0: state <= data ? S1 : S0;
                S1: state <= data ? S2 : S0;
                S2: state <= data ? S2 : S3;
                S3: state <= data ? S4 : S0;
                S4: state <= S4; // sticky final state
                default: state <= S0;
            endcase
        end
    end

    assign start_shifting = (state == S4);

endmodule