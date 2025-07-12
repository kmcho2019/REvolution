// Define the states
`define A 2'b00
`define B 2'b01
`define C 2'b10
`define D 2'b11

module TopModule(
    input  clk,
    input  reset,
    input  in,
    output out
);

reg [1:0] state, next_state;

// Output logic
always @(*) begin
    case(state)
        `A: out = 1'b0;
        `B: out = 1'b0;
        `C: out = 1'b0;
        `D: out = 1'b1;
        default: out = 1'b0;
    endcase
end

// Next state logic
always @(posedge clk) begin
    if (reset) begin
        state <= `A;
    end else begin
        case(state)
            `A: if (!in) begin
                state <= `A;
            end else begin
                state <= `B;
            end
            `B: if (!in) begin
                state <= `C;
            end else begin
                state <= `B;
            end
            `C: if (!in) begin
                state <= `A;
            end else begin
                state <= `D;
            end
            `D: if (!in) begin
                state <= `C;
            end else begin
                state <= `B;
            end
            default: state <= `A;
        endcase
    end
end

endmodule