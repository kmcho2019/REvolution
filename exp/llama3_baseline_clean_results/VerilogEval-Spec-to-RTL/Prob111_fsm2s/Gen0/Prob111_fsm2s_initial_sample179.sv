module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

// Define states
localparam OFF = 1'b0;
localparam ON  = 1'b1;

// Current state register
reg state;

// Combinational logic to determine next state
always @(*) begin
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

// Sequential logic to update current state
always @(posedge clk) begin
    if (reset) begin
        state <= OFF;
    end else begin
        reg next_state;
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
        state <= next_state;
    end
end

// Output logic
assign out = state;

endmodule