module TopModule(
    input  clk,
    input  areset,
    input  j,
    input  k,
    output out
);

reg [1:0] state; // 2 states: 2'b00 for OFF, 2'b01 for ON
reg [1:0] next_state;

always @(*) begin // Combinational logic
    case(state)
        2'b00: begin // State OFF
            if(j)
                next_state = 2'b01; // Transition to ON if j=1
            else
                next_state = 2'b00; // Stay in OFF if j=0
        end
        2'b01: begin // State ON
            if(k)
                next_state = 2'b00; // Transition to OFF if k=1
            else
                next_state = 2'b01; // Stay in ON if k=0
        end
        default: next_state = 2'b00; // Default state
    endcase
end

always @(posedge clk or posedge areset) begin // Sequential logic
    if(areset) begin // Asynchronous reset
        state <= 2'b00; // Reset to state OFF
    end else begin
        state <= next_state; // Update state
    end
end

assign out = (state == 2'b01); // Output is 1 in state ON, 0 in state OFF

endmodule