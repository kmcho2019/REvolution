module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output reg z
);

    localparam [1:0]
        S0 = 2'd0,
        S1 = 2'd1,
        S2 = 2'd2;

    reg [1:0] state;

    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            state <= S0;
            z <= 1'b0;
        end else begin
            case(state)
                S0: begin
                    if (x) state <= S1;
                    else   state <= S0;
                    z <= 1'b0;
                end
                S1: begin
                    if (x) state <= S1;
                    else   state <= S2;
                    z <= 1'b0;
                end
                S2: begin
                    if (x) begin
                        state <= S1;
                        z <= 1'b1;
                    end else begin
                        state <= S0;
                        z <= 1'b0;
                    end
                end
                default: begin
                    state <= S0;
                    z <= 1'b0;
                end
            endcase
        end
    end

endmodule