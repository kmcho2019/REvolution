`define STATE_A 2'b00
`define STATE_B 2'b01
`define STATE_C 2'b10
`define STATE_D 2'b11

module TopModule(
    input  clk,
    input  reset,
    input  in,
    output out
);

reg [1:0] currentState;
reg [1:0] nextState;

always @(posedge clk) begin
    if (reset) begin
        currentState <= `STATE_A;
    end else begin
        case (currentState)
            `STATE_A: begin
                if (~in) begin
                    nextState <= `STATE_A;
                end else begin
                    nextState <= `STATE_B;
                end
            end
            `STATE_B: begin
                if (~in) begin
                    nextState <= `STATE_C;
                end else begin
                    nextState <= `STATE_B;
                end
            end
            `STATE_C: begin
                if (~in) begin
                    nextState <= `STATE_A;
                end else begin
                    nextState <= `STATE_D;
                end
            end
            `STATE_D: begin
                if (~in) begin
                    nextState <= `STATE_C;
                end else begin
                    nextState <= `STATE_B;
                end
            end
            default: begin
                nextState <= `STATE_A;
            end
        endcase
        currentState <= nextState;
    end
end

always @(*) begin
    case (currentState)
        `STATE_A: out = 1'b0;
        `STATE_B: out = 1'b0;
        `STATE_C: out = 1'b0;
        `STATE_D: out = 1'b1;
        default: out = 1'b0;
    endcase
end

initial begin
    currentState <= `STATE_A;
end

endmodule