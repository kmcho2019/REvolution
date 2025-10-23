module TopModule(
    input clk,
    input a,
    output reg [2:0] q
);

reg [1:0] state;

always @(posedge clk) begin
    case (state)
        2'b00: begin // S_RESET
            if (a) begin
                q <= 4;
                state <= 2'b00;
            end else begin
                q <= q + 1;
                state <= 2'b01;
            end
        end
        2'b01: begin // S_COUNT
            if (a) begin
                q <= 4;
                state <= 2'b00;
            end else begin
                if (q == 6) begin
                    q <= 0;
                    state <= 2'b10;
                end else begin
                    q <= q + 1;
                    state <= 2'b01;
                end
            end
        end
        2'b10: begin // S_WRAP
            if (a) begin
                q <= 4;
                state <= 2'b00;
            end else begin
                q <= q + 1;
                state <= 2'b01;
            end
        end
        default: begin
            q <= 4;
            state <= 2'b00;
        end
    endcase
end

initial begin
    q <= 4;
    state <= 2'b00;
end

endmodule