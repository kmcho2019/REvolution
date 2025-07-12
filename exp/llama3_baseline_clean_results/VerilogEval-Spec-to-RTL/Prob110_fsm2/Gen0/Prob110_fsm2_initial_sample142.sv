module TopModule (
    input       clk,
    input       areset,
    input       j,
    input       k,
    output      out
);

// Define states
enum logic [1:0] {OFF, ON} state, next_state;

// Output logic
assign out = (state == ON) ? 1'b1 : 1'b0;

// State transition logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= OFF;
    end else begin
        case (state)
            OFF: begin
                if (j) begin
                    state <= ON;
                end else begin
                    state <= OFF;
                end
            end
            ON: begin
                if (k) begin
                    state <= OFF;
                end else begin
                    state <= ON;
                end
            end
            default: state <= OFF;
        endcase
    end
end

endmodule