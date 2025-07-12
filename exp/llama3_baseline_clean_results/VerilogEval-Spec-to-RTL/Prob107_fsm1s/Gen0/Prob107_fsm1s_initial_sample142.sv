module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

reg [0:0] state; // 0 for A, 1 for B
reg [0:0] next_state;

always @(*) begin
    case(state)
        1'b0: begin // state A
            if (~in)
                next_state = 1'b1; // A -> B
            else
                next_state = 1'b0; // A -> A
        end
        1'b1: begin // state B
            if (~in)
                next_state = 1'b1; // B -> B
            else
                next_state = 1'b1; // B -> B
        end
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        state <= 1'b1; // reset to state B
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case(state)
        1'b0: out = 1'b0; // output in state A
        1'b1: out = 1'b1; // output in state B
    endcase
end

endmodule