module TopModule (
    input  clk,
    input  areset,
    input  x,
    output z
);

reg [1:0] state;
reg [1:0] next_state;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b10; // reset to state A
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case (state)
        2'b10: begin // state A
            if (x == 1'b0) begin
                next_state = 2'b10; // stay in state A
                z = 1'b0;
            end else begin
                next_state = 2'b01; // transition to state B
                z = 1'b1;
            end
        end
        2'b01: begin // state B
            if (x == 1'b0) begin
                next_state = 2'b01; // stay in state B
                z = 1'b1;
            end else begin
                next_state = 2'b01; // stay in state B
                z = 1'b0;
            end
        end
        default: begin
            next_state = 2'b10; // default to state A
            z = 1'b0;
        end
    endcase
end

endmodule