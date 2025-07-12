module TopModule (
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

    // One-hot states representing the sequence detection progress
    reg [3:0] state;

    localparam S0 = 4'b0001; // no match
    localparam S1 = 4'b0010; // matched '1'
    localparam S2 = 4'b0100; // matched '11'
    localparam S3 = 4'b1000; // matched '110'

    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            start_shifting <= 0;
        end else if (!start_shifting) begin
            case(state)
                S0: state <= data ? S1 : S0;
                S1: state <= data ? S2 : S0;
                S2: state <= data ? S2 : S3;
                S3: begin
                    if (data) begin
                        start_shifting <= 1; // pattern detected
                        state <= S3;          // remain here after detection
                    end else begin
                        state <= S0;
                    end
                end
                default: state <= S0;
            endcase
        end
    end

endmodule