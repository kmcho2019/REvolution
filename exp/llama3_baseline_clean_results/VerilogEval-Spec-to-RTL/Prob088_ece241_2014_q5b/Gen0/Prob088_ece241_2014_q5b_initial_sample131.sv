module TopModule(
    input  clk,
    input  areset,
    input  x,
    output z
);

reg [1:0] state; // one-hot encoding for two states
reg [1:0] next_state;

// one-hot encoding: state A = 1, state B = 2
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 1; // reset to state A
    end else begin
        case (state)
            1: begin // state A
                if (x == 1) begin
                    state <= 2; // go to state B
                end else begin
                    state <= 1; // stay in state A
                end
            end
            2: begin // state B
                state <= 2; // stay in state B
            end
            default: state <= 1; // default to state A
        endcase
    end
end

always @(*) begin
    case (state)
        1: begin // state A
            if (x == 0) begin
                z = 0;
            end else begin
                z = 1;
            end
        end
        2: begin // state B
            if (x == 0) begin
                z = 1;
            end else begin
                z = 0;
            end
        end
        default: z = 0; // default output
    endcase
end

endmodule