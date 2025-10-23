`define A 2'b00
`define B 2'b01
`define C 2'b10
`define D 2'b11

module TopModule (
    input  clk,
    input  areset,
    input  in,
    output reg out
);

reg [1:0] state, next_state;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= `A;
    end else begin
        case (state)
            `A: begin
                if (in == 1'b0) begin
                    state <= `A;
                end else begin
                    state <= `B;
                end
            end
            `B: begin
                if (in == 1'b0) begin
                    state <= `C;
                end else begin
                    state <= `B;
                end
            end
            `C: begin
                if (in == 1'b0) begin
                    state <= `A;
                end else begin
                    state <= `D;
                end
            end
            `D: begin
                if (in == 1'b0) begin
                    state <= `C;
                end else begin
                    state <= `B;
                end
            end
        endcase
    end
end

always @(*) begin
    case (state)
        `A, `B, `C: out = 1'b0;
        `D: out = 1'b1;
    endcase
end

endmodule