module TopModule (
    input  clk,
    input  areset,
    input  j,
    input  k,
    output out
);

parameter OFF = 1'b0;
parameter ON  = 1'b1;

reg [0:0] state, next_state;

always @ (posedge clk or posedge areset) begin
    if (areset) begin
        state <= OFF;
    end else begin
        state <= next_state;
    end
end

always @ (state or j or k) begin
    case (state)
        OFF: begin
            if (j) begin
                next_state = ON;
            end else begin
                next_state = OFF;
            end
        end
        ON: begin
            if (k) begin
                next_state = OFF;
            end else begin
                next_state = ON;
            end
        end
        default: next_state = OFF;
    endcase
end

always @ (state) begin
    case (state)
        OFF: out = 1'b0;
        ON:  out = 1'b1;
        default: out = 1'b0;
    endcase
end

endmodule