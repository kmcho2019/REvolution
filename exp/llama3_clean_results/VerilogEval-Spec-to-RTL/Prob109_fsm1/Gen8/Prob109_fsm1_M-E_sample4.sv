module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

reg [1:0] state_reg; // 2-bit register to hold the state (A or B)

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state_reg <= 2'b01; // asynchronous reset to state B
    end else begin
        case (state_reg)
            2'b01: // state B
                state_reg <= in ? 2'b01 : 2'b00;
            2'b00: // state A
                state_reg <= in ? 2'b00 : 2'b01;
            default:
                state_reg <= 2'b01; // default to state B
        endcase
    end
end

assign out = state_reg[0]; // assign output as the current state (A or B)

endmodule