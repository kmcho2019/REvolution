module TopModule(
    input clk,
    input areset,
    input j,
    input k,
    output reg out
);

// Define the states
parameter OFF = 1'b0;
parameter ON = 1'b1;

reg current_state;

// Next state logic
always @(*) begin
    case(current_state)
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

// Output logic
always @(*) begin
    case(current_state)
        OFF: out = 1'b0;
        ON: out = 1'b1;
        default: out = 1'b0;
    endcase
end

// State register
reg next_state;
always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= OFF;
    end else begin
        current_state <= next_state;
    end
end

endmodule