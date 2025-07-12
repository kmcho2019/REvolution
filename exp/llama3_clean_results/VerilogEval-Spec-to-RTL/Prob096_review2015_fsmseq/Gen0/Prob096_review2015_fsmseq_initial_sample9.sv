module TopModule(
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

reg [1:0] state;

localparam S0 = 2'b00;
localparam S1 = 2'b01;
localparam S2 = 2'b10;
localparam S3 = 2'b11;
localparam S4 = 2'b00; // Reusing S0 as the final state

always @(posedge clk) begin
    if (reset) begin
        state <= S0;
        start_shifting <= 0;
    end else begin
        case (state)
            S0: begin
                if (data == 1'b1) begin
                    state <= S1;
                end else begin
                    state <= S0;
                end
            end
            S1: begin
                if (data == 1'b1) begin
                    state <= S2;
                end else if (data == 1'b0) begin
                    state <= S0;
                end
            end
            S2: begin
                if (data == 1'b0) begin
                    state <= S3;
                end else if (data == 1'b1) begin
                    state <= S1;
                end
            end
            S3: begin
                if (data == 1'b1) begin
                    state <= S4;
                    start_shifting <= 1;
                end else begin
                    state <= S0;
                end
            end
            S4: begin
                // Stay in this state, start_shifting remains 1
            end
            default: state <= S0;
        endcase
    end
end

endmodule