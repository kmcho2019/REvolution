module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output reg z
);

    // State encoding
    localparam [1:0]
        S_IDLE = 2'd0,
        S_1    = 2'd1,
        S_10   = 2'd2;

    reg [1:0] state;

    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            state <= S_IDLE;
            z <= 1'b0;
        end else begin
            case(state)
                S_IDLE: begin
                    z <= 1'b0;
                    if (x)
                        state <= S_1;
                    else
                        state <= S_IDLE;
                end
                S_1: begin
                    z <= 1'b0;
                    if (x)
                        state <= S_1;
                    else
                        state <= S_10;
                end
                S_10: begin
                    // Output asserted here on detecting '101'
                    z <= x;
                    if (x)
                        state <= S_1;
                    else
                        state <= S_IDLE;
                end
                default: begin
                    state <= S_IDLE;
                    z <= 1'b0;
                end
            endcase
        end
    end

endmodule