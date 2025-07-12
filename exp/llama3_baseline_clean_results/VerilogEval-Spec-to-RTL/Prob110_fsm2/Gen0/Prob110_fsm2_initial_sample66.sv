module TopModule(
    input  clk,
    input  areset,
    input  j,
    input  k,
    output out
);

// Define states
parameter OFF = 1'b0;
parameter ON = 1'b1;

// Declare reg to hold the current state
reg current_state;

// Initialize output based on state
assign out = current_state;

// State transition logic
always @(*) begin
    if (areset) begin
        current_state <= OFF;
    end else begin
        case (current_state)
            OFF: begin
                if (j) begin
                    current_state <= ON;
                end else begin
                    current_state <= OFF;
                end
            end
            ON: begin
                if (k) begin
                    current_state <= OFF;
                end else begin
                    current_state <= ON;
                end
            end
            default: current_state <= OFF;
        endcase
    end
end

// For simulation, we can add initial condition
initial begin
    $display("OFF State: out = %b", out);
end

endmodule