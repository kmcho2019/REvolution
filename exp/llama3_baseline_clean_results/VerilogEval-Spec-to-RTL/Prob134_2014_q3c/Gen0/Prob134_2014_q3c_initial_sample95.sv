module TopModule(
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

reg [2:0] current_state;
reg [2:0] next_state;

// Initialize the current state to 000
initial current_state = 3'b000;

// Determine the next state and output z based on the current state and input x
always @(*) begin
    case (current_state)
        3'b000: if (!x) next_state = 3'b000; else next_state = 3'b001;
        3'b001: if (!x) next_state = 3'b001; else next_state = 3'b100;
        3'b010: if (!x) next_state = 3'b010; else next_state = 3'b001;
        3'b011: if (!x) next_state = 3'b001; else next_state = 3'b010;
        3'b100: if (!x) next_state = 3'b011; else next_state = 3'b100;
        default: next_state = 3'b000;
    endcase

    // Determine the output z
    if ((current_state == 3'b011) || (current_state == 3'b100)) begin
        z = 1'b1;
    end else begin
        z = 1'b0;
    end
end

// Update the current state on every clock cycle
always @(posedge clk) begin
    current_state <= next_state;
    Y0 <= next_state[0];
end

endmodule