module TopModule(
    input clk,
    input a,
    output reg [2:0] q
);

reg [1:0] state;

always @(posedge clk) begin
    case(state)
        2'b00: begin // S0
            if (a) begin
                q <= 4;
                state <= 2'b00;
            end else begin
                q <= 5;
                state <= 2'b01;
            end
        end
        2'b01: begin // S1
            if (a) begin
                q <= 4;
                state <= 2'b00;
            end else begin
                q <= 6;
                state <= 2'b10;
            end
        end
        2'b10: begin // S2
            if (a) begin
                q <= 4;
                state <= 2'b00;
            end else begin
                q <= 0;
                state <= 2'b11;
            end
        end
        2'b11: begin // S3
            if (a) begin
                q <= 4;
                state <= 2'b00;
            end else begin
                q <= 1;
                state <= 2'b01;
            end
        end
    endcase
end

initial begin
    state = 2'b00;
    q = 4;
end

endmodule