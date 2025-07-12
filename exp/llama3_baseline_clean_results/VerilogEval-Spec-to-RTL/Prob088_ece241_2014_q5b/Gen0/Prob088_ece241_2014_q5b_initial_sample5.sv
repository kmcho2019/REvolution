module TopModule(
    input  clk,
    input  areset,
    input  x,
    output z
);

reg [1:0] state; // state A = 2'b01, state B = 2'b10
reg [1:0] next_state;
reg z_reg;

always @(*) begin
    case (state)
        2'b01: begin // state A
            if (x == 0) begin
                next_state = 2'b01; // stay in A
                z_reg = 0;
            end else begin
                next_state = 2'b10; // go to B
                z_reg = 1;
            end
        end
        2'b10: begin // state B
            if (x == 0) begin
                next_state = 2'b10; // stay in B
                z_reg = 1;
            end else begin
                next_state = 2'b10; // stay in B
                z_reg = 0;
            end
        end
        default: begin // this should never happen
            next_state = 2'b01; // go to A
            z_reg = 0;
        end
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b01; // reset to state A
        z <= 0;
    end else begin
        state <= next_state;
        z <= z_reg;
    end
end

endmodule