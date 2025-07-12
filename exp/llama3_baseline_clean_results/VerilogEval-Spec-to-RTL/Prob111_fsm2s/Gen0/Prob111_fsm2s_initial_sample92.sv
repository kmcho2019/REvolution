module TopModule(
    input           clk,
    input           reset,
    input           j,
    input           k,
    output reg      out
);

reg [1:0] current_state;
reg [1:0] next_state;

// Define states
parameter OFF = 2'b00;
parameter ON  = 2'b01;

// Determine next state
always @(*) begin
    case(current_state)
        OFF: begin
            if (j == 1'b1)
                next_state = ON;
            else
                next_state = OFF;
        end
        ON: begin
            if (k == 1'b1)
                next_state = OFF;
            else
                next_state = ON;
        end
        default: next_state = OFF;
    endcase
end

// Update current state and output
always @(posedge clk) begin
    if (reset) begin
        current_state <= OFF;
    end else begin
        current_state <= next_state;
    end
end

// Determine output
always @(*) begin
    case(current_state)
        OFF: out = 1'b0;
        ON: out = 1'b1;
        default: out = 1'b0;
    endcase
end

initial begin
    current_state = OFF;
end

endmodule