module TopModule(
    input  clk,
    input  areset,
    input  j,
    input  k,
    output out
);

reg [0:0] current_state; // 1-bit signal for the current state
reg [0:0] next_state;    // 1-bit signal for the next state

// Define the states
localparam OFF = 1'b0;
localparam ON  = 1'b1;

// Output logic
assign out = current_state;

// State transition logic
always @(*) begin
    case(current_state)
        OFF: begin
            if (j == 1'b1) begin
                next_state = ON;
            end else begin
                next_state = OFF;
            end
        end
        ON: begin
            if (k == 1'b1) begin
                next_state = OFF;
            end else begin
                next_state = ON;
            end
        end
        default: next_state = OFF;
    endcase
end

// State register
always @(posedge clk or posedge areset) begin
    if (areset == 1'b1) begin
        current_state <= OFF;
    end else begin
        current_state <= next_state;
    end
end

endmodule