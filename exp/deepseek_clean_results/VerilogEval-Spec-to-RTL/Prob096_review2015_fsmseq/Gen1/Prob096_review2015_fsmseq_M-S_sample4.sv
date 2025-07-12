module TopModule (
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

    // States
    reg [1:0] state;

    // State transition and output logic
    always @(posedge clk) begin
        if (reset) begin
            state <= 2'b00;
            start_shifting <= 1'b0;
        end else begin
            case (state)
                2'b00: begin // IDLE
                    start_shifting <= 1'b0;
                    state <= data ? 2'b01 : 2'b00;
                end
                2'b01: begin // S1
                    state <= data ? 2'b10 : 2'b00;
                end
                2'b10: begin // S2
                    state <= data ? 2'b10 : 2'b11;
                end
                2'b11: begin // S3 (implicit)
                    start_shifting <= data;
                    state <= data ? 2'b11 : 2'b00;
                end
            endcase
        end
    end

endmodule