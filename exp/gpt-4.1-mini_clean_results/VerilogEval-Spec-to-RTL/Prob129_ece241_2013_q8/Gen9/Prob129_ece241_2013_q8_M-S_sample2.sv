module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output reg z
);

    localparam S0 = 2'd0; // no match
    localparam S1 = 2'd1; // matched '1'
    localparam S2 = 2'd2; // matched '10'

    reg [1:0] state;

    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            state <= S0;
            z <= 1'b0;
        end else begin
            case (state)
                S0: begin
                    if (x) begin
                        state <= S1;
                        z <= 1'b0;
                    end else begin
                        state <= S0;
                        z <= 1'b0;
                    end
                end
                S1: begin
                    if (x) begin
                        state <= S1;
                        z <= 1'b0;
                    end else begin
                        state <= S2;
                        z <= 1'b0;
                    end
                end
                S2: begin
                    if (x) begin
                        state <= S1;
                        z <= 1'b1; // sequence "101" detected
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