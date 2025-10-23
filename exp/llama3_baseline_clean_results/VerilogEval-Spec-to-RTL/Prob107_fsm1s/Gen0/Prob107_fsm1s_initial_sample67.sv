module TopModule(
    input  clk,
    input  reset,
    input  in,
    output out
);

reg [0:0] state; // 1-bit state register
reg [0:0] next_state; // 1-bit next state register

always @(*) begin
    case (state)
        1'b0: begin // state B
            out = 1'b1;
            if (in == 1'b0) begin
                next_state = 1'b1; // go to state A
            end else begin
                next_state = 1'b0; // stay in state B
            end
        end
        1'b1: begin // state A
            out = 1'b0;
            if (in == 1'b0) begin
                next_state = 1'b0; // go to state B
            end else begin
                next_state = 1'b1; // stay in state A
            end
        end
        default: begin
            out = 1'bx; // unknown output for unknown state
            next_state = 1'bx; // unknown next state for unknown state
        end
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        state <= 1'b0; // reset to state B
    end else begin
        state <= next_state;
    end
end

endmodule