module TopModule (
    input clk,
    input reset,
    input x,
    output reg z
);

    // Gray code state encoding
    parameter S0 = 3'b000;
    parameter S1 = 3'b001;
    parameter S2 = 3'b011;
    parameter S3 = 3'b010;
    parameter S4 = 3'b110;

    reg [2:0] state;

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
                    state <= x ? S4 : S1;
                    z <= 0;
                end
                S2: begin
                    state <= x ? S1 : S2;
                    z <= 0;
                end
                S3: begin
                    state <= x ? S2 : S1;
                    z <= x ? 1 : 0;  // Mealy output
                end
                S4: begin
                    state <= x ? S4 : S3;
                    z <= x ? 1 : 0;  // Mealy output
                end
                default: begin
                    state <= S0;
                    z <= 0;
                end
            endcase
        end
    end

endmodule