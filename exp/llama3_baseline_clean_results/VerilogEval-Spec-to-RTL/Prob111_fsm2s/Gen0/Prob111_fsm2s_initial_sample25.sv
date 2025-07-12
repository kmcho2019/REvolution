module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output out
);

// Define states
parameter OFF = 1'b0;
parameter ON = 1'b1;

// State variable
reg state;

// Assign output based on state
assign out = state;

// Next state logic
always @(posedge clk) begin
    if (reset) begin
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