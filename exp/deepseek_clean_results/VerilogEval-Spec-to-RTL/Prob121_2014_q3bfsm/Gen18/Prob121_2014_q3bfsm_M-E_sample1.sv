module TopModule (
    input clk,
    input reset,
    input x,
    output reg z
);

    // Reduced state encoding for Mealy implementation
    parameter [1:0] S0 = 2'b00,
                    S1 = 2'b01,
                    S2 = 2'b10;

    reg [1:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            z <= 0;
        end
        else begin
            case (state)
                S0: begin
                    state <= x ? S1 : S0;
                    z <= 0;
                end
                S1: begin
                    state <= x ? S2 : S1;
                    z <= 0;
                end
                S2: begin
                    if (x) begin
                        state <= S2;
                        z <= 1;
                    end
                    else begin
                        state <= S1;
                        z <= 1;
                    end
                end
                default: begin
                    state <= S0;
                    z <= 0;
                end
            endcase
        end
    end

endmodule