module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

reg [1:0] state; // idle: 2'b00, found_1: 2'b01, found_11: 2'b10, found_110: 2'b11
                // found_1101 is represented by start_shifting being 1

always @(posedge clk) begin
    if(reset) begin
        start_shifting <= 0;
        state <= 2'b00;
    end else begin
        case(state)
            2'b00: begin // idle
                if(data) begin // first 1 in sequence 1101
                    state <= 2'b01;
                end
            end
            2'b01: begin // found_1
                if(data) begin // second 1 in sequence 1101
                    state <= 2'b10;
                end else begin
                    state <= 2'b00; // 0 in sequence, go back to idle
                end
            end
            2'b10: begin // found_11
                if(data) begin // second 1 in sequence 1101, go to found_110
                    state <= 2'b11;
                end else begin // 0 in sequence, go back to found_1
                    state <= 2'b01;
                end
            end
            2'b11: begin // found_110
                if(!data) begin // 0 in sequence 1101
                    state <= 2'b00; // go back to idle
                end else begin // last 1 in sequence 1101
                    start_shifting <= 1;
                end
            end
            default: begin
                state <= 2'b00; // invalid state, go back to idle
            end
        endcase
    end
end

endmodule