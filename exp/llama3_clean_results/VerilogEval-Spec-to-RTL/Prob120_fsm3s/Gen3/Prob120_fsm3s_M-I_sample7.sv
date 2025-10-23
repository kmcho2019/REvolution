module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

// Current state
reg [1:0] current_state;

// Output logic using continuous assignment
assign out = (current_state == 2'b11);

// Sequential logic and state transition logic combined
always_ff @(posedge clk) begin
    if (reset) begin
        current_state <= 2'b00;
    end else begin
        case (current_state)
            2'b00: current_state <= in? 2'b01 : current_state;
            2'b01: current_state <= in? current_state : 2'b10;
            2'b10: current_state <= in? 2'b11 : 2'b00;
            2'b11: current_state <= in? 2'b01 : 2'b10;
        endcase
    end
end

endmodule