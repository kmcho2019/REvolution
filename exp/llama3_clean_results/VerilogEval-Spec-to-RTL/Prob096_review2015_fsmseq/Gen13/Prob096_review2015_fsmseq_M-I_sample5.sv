module TopModule(
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

reg [1:0] state; // States: S0 (0), S1 (1), S2 (2), S3 (3)

always @(posedge clk) begin
    if (reset) begin
        state <= 0;
        start_shifting <= 0;
    end else begin
        case (state)
            0: // S0
                if (data == 1) begin
                    state <= 1;
                end
            1: // S1
                if (data == 1) begin
                    state <= 2;
                end else begin
                    state <= 0;
                end
            2: // S2
                if (data == 0) begin
                    state <= 3;
                end else begin
                    state <= 1;
                end
            3: // S3
                // Once in S3 and start_shifting is 1, stay here until reset
                if (start_shifting) begin
                    // Do nothing, stay in this state
                end else if (data == 1) begin
                    start_shifting <= 1;
                end else begin
                    state <= 0;
                end
            default: state <= 0;
        endcase
    end
end

endmodule