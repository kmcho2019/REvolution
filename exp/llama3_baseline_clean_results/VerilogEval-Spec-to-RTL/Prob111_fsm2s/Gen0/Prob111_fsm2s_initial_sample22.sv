module TopModule(
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

// Define states
localparam OFF = 1'b0;
localparam ON  = 1'b1;

// Declare state register
reg current_state;

// Initialize output
assign out = current_state;

// State machine
always @ (posedge clk) begin
    if (reset) begin
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
        endcase
    end
end

endmodule