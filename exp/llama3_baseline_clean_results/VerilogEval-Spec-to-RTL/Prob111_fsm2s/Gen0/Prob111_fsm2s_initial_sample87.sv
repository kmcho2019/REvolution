module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output out
);

reg [0:0] state; // 1-bit signal to represent the current state
reg [0:0] next_state; // 1-bit signal to represent the next state

// Define the states
localparam OFF = 1'b0;
localparam ON = 1'b1;

// Output logic
assign out = state;

// Next state logic
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
        default: begin
            next_state = OFF;
        end
    endcase
end

// State register with synchronous reset
always @(posedge clk) begin
    if(reset == 1'b1) begin
        state <= OFF;
    end else begin
        state <= next_state;
    end
end

endmodule