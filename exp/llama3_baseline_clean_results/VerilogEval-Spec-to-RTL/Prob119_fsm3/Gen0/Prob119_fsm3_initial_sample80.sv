`define A 2'd0
`define B 2'd1
`define C 2'd2
`define D 2'd3

module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

reg [1:0] current_state;
reg [1:0] next_state;
reg out_reg;

always @(*) begin
    case(current_state)
        `A: begin
            if (!in) next_state = `A;
            else next_state = `B;
            out_reg = 1'b0;
        end
        `B: begin
            if (!in) next_state = `C;
            else next_state = `B;
            out_reg = 1'b0;
        end
        `C: begin
            if (!in) next_state = `A;
            else next_state = `D;
            out_reg = 1'b0;
        end
        `D: begin
            if (!in) next_state = `C;
            else next_state = `B;
            out_reg = 1'b1;
        end
        default: begin
            next_state = `A;
            out_reg = 1'b0;
        end
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= `A;
        out <= 1'b0;
    end
    else begin
        current_state <= next_state;
        out <= out_reg;
    end
end

endmodule