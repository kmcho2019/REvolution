module TopModule(
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

reg [2:0] state; // States: S0 (0), S1 (1), S2 (2), S3 (3), S4 (4, but not needed as once reached, start_shifting is set and stays set until reset)

always @(posedge clk) begin
    if (reset) begin
        state <= 0;
        start_shifting <= 0;
    end else begin
        case (state)
            0: // S0
                if (data == 1) begin
                    state <= 1;
                end else begin
                    state <= 0;
                end
            1: // S1
                if (data == 1) begin
                    state <= 2;
                end else if (data == 0) begin
                    state <= 0;
                end else begin
                    state <= 1;
                end
            2: // S2
                if (data == 0) begin
                    state <= 3;
                end else begin
                    state <= 1;
                end
            3: // S3
                if (data == 1) begin
                    state <= 3; // Actually, set start_shifting here and don't change state again until reset
                    start_shifting <= 1;
                end else begin
                    state <= 0;
                end
            default: state <= 0;
        endcase
    end
end

endmodule