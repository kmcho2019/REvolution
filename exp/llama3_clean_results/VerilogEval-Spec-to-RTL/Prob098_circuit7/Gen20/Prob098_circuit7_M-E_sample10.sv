module TopModule(
    input clk,
    input a,
    output reg q
);

reg [1:0] state = 2'b00; // S0: 00, S1: 01

always @(*) begin
    case(state)
        2'b00: begin // S0
            if (~a) begin
                q = 1'b1;
                state = 2'b00;
            end else begin
                q = 1'b1;
                state = 2'b01;
            end
        end
        2'b01: begin // S1
            if (~a) begin
                q = 1'b0;
                state = 2'b00;
            end else begin
                q = 1'b0;
                state = 2'b01;
            end
        end
        default: begin
            q = 1'b0;
            state = 2'b00;
        end
    endcase
end

always @(posedge clk) begin
    state <= state;
end

endmodule