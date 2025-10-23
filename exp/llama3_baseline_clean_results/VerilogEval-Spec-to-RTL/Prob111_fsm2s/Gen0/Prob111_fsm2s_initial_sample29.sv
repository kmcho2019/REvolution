module TopModule(
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

// Define states
parameter OFF = 1'b0;
parameter ON  = 1'b1;

// State variable
reg state;
reg next_state;

// Combinational logic for next state
always @(*) begin
    case(state)
        OFF: begin
            if(j == 1'b1) begin
                next_state = ON;
            end else begin
                next_state = OFF;
            end
        end
        ON: begin
            if(k == 1'b1) begin
                next_state = OFF;
            end else begin
                next_state = ON;
            end
        end
        default: next_state = OFF;
    endcase
end

// Sequential logic for state update
always @(posedge clk) begin
    if(reset == 1'b1) begin
        state <= OFF;
    end else begin
        state <= next_state;
    end
end

// Moore machine output
assign out = state;

endmodule