module TopModule(
    input clk,
    input aresetn,
    input x,
    output z
);

reg [1:0] state; // 2-bit register to store the current state
reg [1:0] next_state; // 2-bit register to store the next state

// State encoding:
// S0: 2'b00
// S1: 2'b01
// S2: 2'b10

// Initialize the output
assign z = (state == 2'b10) && x;

// Next state logic
always @(*) begin
    case(state)
        2'b00: if(x) next_state = 2'b01; else next_state = 2'b00;
        2'b01: if(!x) next_state = 2'b10; else next_state = 2'b01;
        2'b10: if(x) next_state = 2'b01; else next_state = 2'b00;
        default: next_state = 2'b00;
    endcase
end

// State update logic
always @(posedge clk or negedge aresetn) begin
    if(!aresetn) begin
        state <= 2'b00;
    end else begin
        state <= next_state;
    end
end

endmodule