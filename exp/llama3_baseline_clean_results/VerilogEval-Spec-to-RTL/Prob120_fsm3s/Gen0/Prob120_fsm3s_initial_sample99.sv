`define A 2'b00
`define B 2'b01
`define C 2'b10
`define D 2'b11

module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

reg [1:0] current_state;
reg [1:0] next_state;

always @(*) begin
    case (current_state)
        `A: begin
            if (!in)
                next_state = `A;
            else
                next_state = `B;
        end
        `B: begin
            if (!in)
                next_state = `C;
            else
                next_state = `B;
        end
        `C: begin
            if (!in)
                next_state = `A;
            else
                next_state = `D;
        end
        `D: begin
            if (!in)
                next_state = `C;
            else
                next_state = `B;
        end
        default: next_state = `A;
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        current_state <= `A;
    end else begin
        current_state <= next_state;
    end
end

always @(*) begin
    case (current_state)
        `A: out = 0;
        `B: out = 0;
        `C: out = 0;
        `D: out = 1;
        default: out = 0;
    endcase
end

endmodule