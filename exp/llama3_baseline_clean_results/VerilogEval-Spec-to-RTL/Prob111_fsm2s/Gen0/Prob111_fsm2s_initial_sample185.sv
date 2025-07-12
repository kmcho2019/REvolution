module TopModule(
    input           clk,
    input           reset,
    input           j,
    input           k,
    output          out
);

reg [0:0] state, nextState;

// State encoding
parameter OFF = 0, ON = 1;

always @ (posedge clk) begin
    if (reset) begin
        state <= OFF;
    end else begin
        state <= nextState;
    end
end

always @ (*) begin
    case (state)
        OFF: begin
            if (j == 0) begin
                nextState <= OFF;
            end else begin
                nextState <= ON;
            end
        end
        ON: begin
            if (k == 0) begin
                nextState <= ON;
            end else begin
                nextState <= OFF;
            end
        end
        default: begin
            nextState <= OFF;
        end
    endcase
end

always @ (*) begin
    case (state)
        OFF: out <= 0;
        ON:  out <= 1;
        default: out <= 0;
    endcase
end

endmodule