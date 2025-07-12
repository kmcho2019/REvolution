module TopModule (
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

reg [1:0] state;
parameter idle = 2'b00, seen_1 = 2'b01, seen_11 = 2'b10, found_sequence = 2'b11;

always @(posedge clk) begin
    if (reset) begin
        state <= idle;
        start_shifting <= 0;
    end else begin
        case(state)
            idle: begin
                if (data == 1) begin
                    state <= seen_1;
                end else begin
                    state <= idle;
                end
            end
            seen_1: begin
                if (data == 1) begin
                    state <= seen_11;
                end else if (data == 0) begin
                    state <= seen_1_0;
                end
            end
            seen_11: begin
                if (data == 0) begin
                    state <= seen_110;
                end else begin
                    state <= seen_1;
                end
            end
            seen_1_0: begin
                if (data == 1) begin
                    state <= seen_1;
                end else begin
                    state <= seen_1_0;
                end
            end
            seen_110: begin
                if (data == 1) begin
                    state <= found_sequence;
                end else begin
                    state <= idle;
                end
            end
            found_sequence: begin
                state <= found_sequence;
            end
        endcase
        if (state == found_sequence) begin
            start_shifting <= 1;
        end else begin
            start_shifting <= 0;
        end
    end
end

reg [1:0] seen_1_0 = 2'b01;

endmodule