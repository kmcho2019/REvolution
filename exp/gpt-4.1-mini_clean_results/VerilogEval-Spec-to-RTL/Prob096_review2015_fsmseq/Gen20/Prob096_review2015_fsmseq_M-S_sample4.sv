module TopModule (
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

    // State encoding: track matched prefix length
    localparam [2:0]
        S0 = 3'b000, // no match
        S1 = 3'b001, // matched '1'
        S2 = 3'b010, // matched "11"
        S3 = 3'b011, // matched "110"
        S4 = 3'b100; // matched "1101" sticky detected state

    reg [2:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            start_shifting <= 1'b0;
        end else begin
            case (state)
                S0: state <= data ? S1 : S0;
                S1: state <= data ? S2 : S0;
                S2: state <= data ? S2 : S3;
                S3: state <= data ? S4 : S0;
                S4: state <= S4; // sticky detected
                default: state <= S0;
            endcase
            start_shifting <= (state == S4);
        end
    end

endmodule