module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

reg [1:0] state; // 2 bits for 4 states (0-3)
localparam S0 = 2'b00, S1 = 2'b01, S2 = 2'b10, S4 = 2'b11;

always @ (posedge clk) begin
    if (reset) begin
        state <= S0;
        start_shifting <= 1'b0;
    end else begin
        case (state)
            S0: begin
                if (data) begin
                    state <= S1;
                end else begin
                    state <= S0;
                end
            end
            S1: begin
                if (data) begin
                    state <= S2;
                end else begin
                    state <= S0;
                end
            end
            S2: begin
                if (~data) begin
                    state <= S4;
                end else begin
                    state <= S1;
                end
            end
            S4: begin
                start_shifting <= 1'b1;
                // Stay in S4 until reset
            end
        endcase
    end
end

endmodule