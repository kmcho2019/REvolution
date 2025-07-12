module TopModule(
    input  clk,
    input  reset,
    input  data,
    output start_shifting
);

reg [1:0] state; // Enumerated type to represent the states
parameter IDLE = 2'b00, GOT_1 = 2'b01, GOT_11 = 2'b10, GOT_110 = 2'b11, GOT_1101 = 2'b12;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        start_shifting <= 0;
    end
    else begin
        case (state)
            IDLE: begin
                if (data) begin
                    state <= GOT_1;
                end
                else begin
                    state <= IDLE;
                end
            end
            GOT_1: begin
                if (data) begin
                    state <= GOT_11;
                end
                else begin
                    state <= IDLE;
                end
            end
            GOT_11: begin
                if (~data) begin
                    state <= GOT_110;
                end
                else begin
                    state <= GOT_1;
                end
            end
            GOT_110: begin
                if (data) begin
                    state <= GOT_1101;
                end
                else begin
                    state <= IDLE;
                end
            end
            default: begin // GOT_1101
                state <= GOT_1101;
            end
        endcase
    end
end

always @(posedge clk) begin
    if (reset) begin
        start_shifting <= 0;
    end
    else if (state == GOT_1101) begin
        start_shifting <= 1;
    end
    else begin
        start_shifting <= 0;
    end
end

endmodule