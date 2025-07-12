module TopModule (
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

    // State encoding: number of matched bits so far
    localparam S0 = 2'b00; // no match
    localparam S1 = 2'b01; // matched '1'
    localparam S2 = 2'b10; // matched '11'
    localparam S3 = 2'b11; // matched '110'

    reg [1:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            start_shifting <= 1'b0;
        end else begin
            if (start_shifting) begin
                // Remain in detected mode
                start_shifting <= 1'b1;
            end else begin
                case(state)
                    S0: state <= data ? S1 : S0;
                    S1: state <= data ? S2 : S0;
                    S2: state <= data ? S2 : S3;
                    S3: if (data) begin
                            state <= S1;       // Because '1' matched after '110'
                            start_shifting <= 1'b1;
                        end else
                            state <= S0;
                    default: state <= S0;
                endcase
            end
        end
    end

endmodule