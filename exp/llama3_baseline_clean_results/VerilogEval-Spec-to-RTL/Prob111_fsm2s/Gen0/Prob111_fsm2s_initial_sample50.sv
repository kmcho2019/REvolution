module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output out
);

reg [1:0] state; // 2 states, so 2 bits
reg [1:0] next_state;

// Define the states
parameter OFF = 2'b00;
parameter ON = 2'b01;

// Define the output based on the current state
always @(posedge clk) begin
    if(reset) begin
        state <= OFF;
    end else begin
        state <= next_state;
    end
end

// Determine the next state based on the current state and inputs
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
        default: next_state = OFF; // Handle invalid states
    endcase
end

// Determine the output based on the current state
assign out = (state == ON)? 1'b1 : 1'b0;

endmodule