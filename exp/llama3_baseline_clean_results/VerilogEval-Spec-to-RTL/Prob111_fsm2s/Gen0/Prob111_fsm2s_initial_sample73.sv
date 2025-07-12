module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output out
);

reg [0:0] state; // 1-bit register to store the current state
reg [0:0] next_state; // 1-bit register to store the next state

// Define the states
parameter OFF = 1'b0;
parameter ON = 1'b1;

// Output logic: out = 1 when state is ON, out = 0 when state is OFF
assign out = (state == ON)? 1'b1 : 1'b0;

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
        default: next_state = OFF;
    endcase
end

// State register with synchronous reset
always @(posedge clk) begin
    if(reset) begin
        state <= OFF;
    end else begin
        state <= next_state;
    end
end

endmodule