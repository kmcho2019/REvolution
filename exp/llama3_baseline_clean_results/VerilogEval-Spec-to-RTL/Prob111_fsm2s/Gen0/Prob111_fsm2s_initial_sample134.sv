module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output out
);

// Define the states
parameter OFF = 1'b0, ON = 1'b1;

// Current and next state signals
reg [0:0] current_state;
reg [0:0] next_state;

// Output logic
assign out = (current_state == ON) ? 1'b1 : 1'b0;

// State transition logic
always @(*) begin
    case(current_state)
        OFF: begin
            if (j) next_state = ON;
            else next_state = OFF;
        end
        ON: begin
            if (k) next_state = OFF;
            else next_state = ON;
        end
        default: next_state = OFF;
    endcase
end

// State update logic
always @(posedge clk or posedge reset) begin
    if (reset) begin
        current_state <= OFF;
    end else begin
        current_state <= next_state;
    end
end

endmodule