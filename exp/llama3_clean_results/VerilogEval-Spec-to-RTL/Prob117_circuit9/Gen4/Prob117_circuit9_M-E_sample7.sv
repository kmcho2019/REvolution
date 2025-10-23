module TopModule(
    input clk,
    input a,
    output reg [2:0] q
);

reg [2:0] state;

always @(posedge clk) begin
    case (state)
        3'b100: begin // state 4
            if (!a) begin
                state <= state + 1;
            end
        end
        3'b101: begin // state 5
            if (!a) begin
                state <= state + 1;
            end
        end
        3'b110: begin // state 6
            if (!a) begin
                state <= 3'b000; // wrap around to 0
            end
        end
        default: begin
            if (a) begin
                state <= 3'b100; // reset to 4
            end else begin
                state <= state + 1;
            end
        end
    endcase
end

initial begin
    state <= 3'b100;
end

assign q = state;

endmodule