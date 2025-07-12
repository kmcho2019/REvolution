module TopModule(
    input       clk,
    input       areset,
    input       j,
    input       k,
    output      out
);

reg [1:0] state, next_state;

// Define states
parameter OFF = 2'b00;
parameter ON  = 2'b01;

// Output logic
always @(*) begin
    case(state)
        OFF: out = 1'b0;
        ON:  out = 1'b1;
        default: out = 1'b0; // Default output for unknown state
    endcase
end

// Next state logic
always @(*) begin
    case(state)
        OFF: begin
            if(j) begin
                next_state = ON;
            end else begin
                next_state = OFF;
            end
        end
        ON: begin
            if(k) begin
                next_state = OFF;
            end else begin
                next_state = ON;
            end
        end
        default: next_state = OFF; // Default next state for unknown current state
    endcase
end

// State register with asynchronous reset
always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= OFF;
    end else begin
        state <= next_state;
    end
end

endmodule