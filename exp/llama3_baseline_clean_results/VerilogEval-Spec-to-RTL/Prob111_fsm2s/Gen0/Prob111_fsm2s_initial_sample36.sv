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

reg current_state;
reg next_state;

// Output logic
assign out = current_state;

// State register
always @(posedge clk or posedge reset) begin
    if (reset) begin
        current_state <= OFF;
    end else begin
        current_state <= next_state;
    end
end

// Next state logic
always @(*) begin
    case (current_state)
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

endmodule