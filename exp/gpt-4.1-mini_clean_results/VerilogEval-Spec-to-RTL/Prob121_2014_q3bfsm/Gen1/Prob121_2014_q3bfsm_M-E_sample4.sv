module TopModule (
    input clk,
    input reset,
    input x,
    output reg z
);

    reg [2:0] state;

    // State encoding parameters
    localparam S0 = 3'd0;
    localparam S1 = 3'd1;
    localparam S2 = 3'd2;
    localparam S3 = 3'd3;
    localparam S4 = 3'd4;

    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            z <= 1'b0;
        end else begin
            case(state)
                S0: begin
                    state <= (x == 1'b0) ? S0 : S1;
                    z <= 1'b0;
                end
                S1: begin
                    state <= (x == 1'b0) ? S1 : S4;
                    z <= 1'b0;
                end
                S2: begin
                    state <= (x == 1'b0) ? S2 : S1;
                    z <= 1'b0;
                end
                S3: begin
                    state <= (x == 1'b0) ? S1 : S2;
                    z <= 1'b1;
                end
                S4: begin
                    state <= (x == 1'b0) ? S3 : S4;
                    z <= 1'b1;
                end
                default: begin
                    state <= S0;
                    z <= 1'b0;
                end
            endcase
        end
    end

endmodule