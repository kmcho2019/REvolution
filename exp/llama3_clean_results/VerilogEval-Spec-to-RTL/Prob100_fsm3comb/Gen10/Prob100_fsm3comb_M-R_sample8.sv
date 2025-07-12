module TopModule(
    input  in,
    input [1:0] state,
    output [1:0] next_state,
    output out
);

    reg [1:0] next_state_reg;
    reg out_reg;

    always @(*) begin
        case(state)
            2'b00: begin
                next_state_reg = in ? 2'b01 : 2'b00;
                out_reg = 1'b0;
            end
            2'b01: begin
                next_state_reg = in ? 2'b01 : 2'b10;
                out_reg = 1'b0;
            end
            2'b10: begin
                next_state_reg = in ? 2'b11 : 2'b00;
                out_reg = 1'b0;
            end
            2'b11: begin
                next_state_reg = in ? 2'b01 : 2'b10;
                out_reg = 1'b1;
            end
            default: begin
                next_state_reg = 2'b00;
                out_reg = 1'b0;
            end
        endcase
    end

    assign next_state = next_state_reg;
    assign out = out_reg;

endmodule