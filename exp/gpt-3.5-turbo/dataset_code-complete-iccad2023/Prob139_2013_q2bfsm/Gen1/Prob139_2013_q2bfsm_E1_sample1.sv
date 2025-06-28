module TopModule (
  input clk,
  input resetn,
  input x,
  input y,
  output reg f,
  output reg g
);

// Define states for each output
reg [1:0] state_f, state_g;

// FSM for output f
always @(posedge clk or negedge resetn) begin
    if (~resetn) begin
        state_f <= 2'b00; // Initialize to state A
        f <= 0;          // Set f to 0
    end
    else begin
        case(state_f)
            2'b00: begin // State A
                f <= 1; // Set f to 1 for one clock cycle
                state_f <= 2'b01;
            end
            2'b01: begin // State B
                f <= 0; // Set f back to 0
                state_f <= 2'b00; // Return to state A
            end
        endcase
    end
end

// FSM for output g
always @(posedge clk or negedge resetn) begin
    if (~resetn) begin
        state_g <= 2'b00; // Initialize to state A
        g <= 0;          // Set g to 0
    end
    else begin
        case(state_g)
            2'b00: begin // State A
                if (x == 1 && #1 x == 0 && #1 x == 1) begin
                    state_g <= 2'b01; // Transition to state B
                end
            end
            2'b01: begin // State B
                if (y == 1) begin
                    g <= 1; // Set g to 1 permanently
                end
                else begin
                    g <= 0; // Set g to 0 permanently
                end
            end
        endcase
    end
end

endmodule