module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

reg [1:0] current_state;

always @(posedge clk) begin
    if (reset) begin
        current_state <= 2'b00; // S0
        start_shifting <= 0;
    end else begin
        case (current_state)
            2'b00: begin // S0
                if (data == 1'b1) begin
                    current_state <= 2'b01; // S1
                end else begin
                    current_state <= 2'b00; // S0
                end
            end
            2'b01: begin // S1
                if (data == 1'b1) begin
                    current_state <= 2'b10; // S2
                end else if (data == 1'b0) begin
                    current_state <= 2'b00; // S0
                end
            end
            2'b10: begin // S2
                if (data == 1'b0) begin
                    current_state <= 2'b11; // S3
                end else if (data == 1'b1) begin
                    current_state <= 2'b10; // S2
                end
            end
            2'b11: begin // S3
                if (data == 1'b1) begin
                    current_state <= 2'b11; // S3
                    start_shifting <= 1;
                end else begin
                    current_state <= 2'b00; // S0
                end
            end
            default: begin
                current_state <= current_state;
                start_shifting <= 1;
            end
        endcase
    end
end

endmodule