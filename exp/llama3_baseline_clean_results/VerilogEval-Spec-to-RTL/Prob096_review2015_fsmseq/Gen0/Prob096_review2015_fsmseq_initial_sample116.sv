module TopModule(
    input  clk,
    input  reset,
    input  data,
    output start_shifting
);

reg [1:0] state; // 4 states: 00 (S0), 01 (S1), 10 (S2), 11 (S3 and S4, distinguished by start_shifting)
reg       start_shifting;

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00;
        start_shifting <= 1'b0;
    end else begin
        case (state)
            2'b00: begin
                if (data) begin
                    state <= 2'b01;
                end
            end
            2'b01: begin
                if (data) begin
                    state <= 2'b10;
                end else begin
                    state <= 2'b00;
                end
            end
            2'b10: begin
                if (data) begin
                    state <= 2'b11;
                end else begin
                    state <= 2'b01;
                end
            end
            2'b11: begin
                if (data) begin
                    // sequence 1101 not found
                    state <= 2'b00;
                end else begin
                    // sequence 1101 found
                    start_shifting <= 1'b1;
                end
            end
        endcase
    end
end

endmodule