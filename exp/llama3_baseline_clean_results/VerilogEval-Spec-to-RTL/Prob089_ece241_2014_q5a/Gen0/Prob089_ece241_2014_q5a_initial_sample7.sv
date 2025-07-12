module TopModule (
    input  clk,
    input  areset,
    input  x,
    output z
);

reg [1:0] state; // 0: initial state, 1: computation state
reg carry; // carry bit for 2's complement computation
reg z_reg; // output register

always @ (posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0; // reset state to initial state
        carry <= 0; // reset carry to 0
        z_reg <= 0; // reset output to 0
    end else begin
        case (state)
            0: begin // initial state
                state <= 1; // transition to computation state
            end
            1: begin // computation state
                carry <= ~x + carry; // update carry bit
                z_reg <= ~x ^ carry; // compute 2's complement bit
            end
        endcase
    end
end

assign z = z_reg; // output the computed 2's complement bit

endmodule