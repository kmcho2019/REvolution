module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

reg [1:0] state;

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00;
        start_shifting <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // Initial state
                if (data == 1'b1) begin
                    state <= 2'b01;
                end
            end
            2'b01: begin // After detecting the first '1'
                if (data == 1'b1) begin
                    state <= 2'b10;
                end else begin
                    state <= 2'b00;
                end
            end
            2'b10: begin // After detecting the second '1'
                if (data == 1'b0) begin
                    state <= 2'b11;
                end else begin
                    state <= 2'b01;
                end
            end
            2'b11: begin // After detecting the '0'
                if (data == 1'b1) begin
                    state <= 2'b10; // Go back to this state, start_shifting will now be set
                end else begin
                    state <= 2'b00;
                end
            end
            default: state <= 2'b00;
        endcase
        if (state == 2'b10 && data == 1'b1) begin
            start_shifting <= 1'b1;
        end
    end
end

endmodule