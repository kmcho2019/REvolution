module TopModule (
    input clk,
    input aresetn,
    input x,
    output reg z
);

    reg [1:0] state;

    localparam S0 = 2'b00;
    localparam S1 = 2'b01;
    localparam S2 = 2'b10;

    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            state <= S0;
            z <= 1'b0;
        end else begin
            case(state)
                S0: begin
                    z <= 1'b0;
                    if (x)
                        state <= S1;
                    else
                        state <= S0;
                end
                S1: begin
                    z <= 1'b0;
                    if (x)
                        state <= S1;
                    else
                        state <= S2;
                end
                S2: begin
                    if (x) begin
                        state <= S1;
                        z <= 1'b1; // Sequence "101" detected
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