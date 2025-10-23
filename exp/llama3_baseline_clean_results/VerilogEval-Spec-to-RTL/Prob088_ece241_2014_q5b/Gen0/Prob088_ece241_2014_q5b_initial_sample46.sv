module TopModule(
    input  clk,
    input  areset,
    input  x,
    output z
);

reg [1:0] state;  // one-hot encoding
reg [1:0] next_state;  // one-hot encoding

// Output logic
always @(state or x) begin
    case (state)
        2'b10: z = ~x;  // state A
        2'b01: z = x;  // state B
        default: z = 1'b0;  // default output
    endcase
end

// State logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b10;  // reset to state A
    end else begin
        case (state)
            2'b10: begin
                if (~x) begin
                    state <= 2'b10;  // stay in state A
                end else begin
                    state <= 2'b01;  // transition to state B
                end
            end
            2'b01: begin
                if (x) begin
                    state <= 2'b01;  // stay in state B
                end else begin
                    state <= 2'b01;  // stay in state B
                end
            end
            default: state <= 2'b10;  // default state
        endcase
    end
end

endmodule