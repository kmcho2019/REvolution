module TopModule(
    input  clk,
    input  reset,
    input  in,
    output out
);

reg [1:0] state;  // 2-state machine, 2 bits needed
reg [1:0] next_state;

always @(posedge clk) begin
    if (reset) begin  // synchronous reset
        state <= 1'b1;  // reset to state B
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case (state)
        1'b0: begin  // state A
            if (!in) begin
                next_state = 1'b1;  // A (out=0) --in=0--> B
            end else begin
                next_state = 1'b0;  // A (out=0) --in=1--> A
            end
        end
        1'b1: begin  // state B
            if (!in) begin
                next_state = 1'b1;  // B (out=1) --in=0--> B
            end else begin
                next_state = 1'b1;  // B (out=1) --in=1--> B
            end
        end
        default: next_state = 1'b1;  // default to state B
    endcase
end

assign out = (state == 1'b1) ? 1'b1 : 1'b0;  // out = 1 in state B, 0 in state A

endmodule