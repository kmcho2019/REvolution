module TopModule (
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

    // State encoding
    localparam S0 = 3'd0; // no match yet
    localparam S1 = 3'd1; // matched '1'
    localparam S2 = 3'd2; // matched '11'
    localparam S3 = 3'd3; // matched '110'
    localparam S4 = 3'd4; // matched '1101' (final state)

    reg [2:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            start_shifting <= 1'b0;
        end else begin
            case (state)
                S0: begin
                    if (data)
                        state <= S1;
                    else
                        state <= S0;
                    start_shifting <= 1'b0;
                end
                S1: begin
                    if (data)
                        state <= S2;
                    else
                        state <= S0;
                    start_shifting <= 1'b0;
                end
                S2: begin
                    if (~data)
                        state <= S3;
                    else
                        state <= S2;
                    start_shifting <= 1'b0;
                end
                S3: begin
                    if (data) begin
                        state <= S4;
                        start_shifting <= 1'b1;
                    end else begin
                        state <= S0;
                        start_shifting <= 1'b0;
                    end
                end
                S4: begin
                    state <= S4;
                    start_shifting <= 1'b1;
                end
                default: begin
                    state <= S0;
                    start_shifting <= 1'b0;
                end
            endcase
        end
    end

endmodule