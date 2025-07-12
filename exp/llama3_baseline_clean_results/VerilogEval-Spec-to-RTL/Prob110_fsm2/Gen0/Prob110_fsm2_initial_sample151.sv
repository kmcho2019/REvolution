module TopModule(
    input  clk,
    input  areset,
    input  j,
    input  k,
    output out
);

parameter OFF = 1'b0;
parameter ON  = 1'b1;

reg current_state;
reg next_state;

always @(*) begin
    case (current_state)
        OFF: begin
            if (j == 1'b1)
                next_state = ON;
            else
                next_state = OFF;
        end
        ON: begin
            if (k == 1'b1)
                next_state = OFF;
            else
                next_state = ON;
        end
        default: next_state = OFF;
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= OFF;
    end else begin
        current_state <= next_state;
    end
end

always @(*) begin
    case (current_state)
        OFF: out = 1'b0;
        ON:  out = 1'b1;
        default: out = 1'b0;
    endcase
end

endmodule