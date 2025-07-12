module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

// Define states using one-hot encoding
reg [1:0] current_state;
localparam STATE_A = 2'b01;
localparam STATE_B = 2'b10;

// Define next state logic and output z
reg [1:0] next_state;
always @(*) begin
    case (current_state)
        STATE_A: begin
            if (x) begin
                next_state = STATE_B;
                z = 1'b1;
            end else begin
                next_state = STATE_A;
                z = 1'b0;
            end
        end
        STATE_B: begin
            if (x) begin
                next_state = STATE_B;
                z = 1'b0;
            end else begin
                next_state = STATE_B;
                z = 1'b1;
            end
        end
        default: begin
            next_state = STATE_A;  // default to state A for unknown states
            z = 1'b0;
        end
    endcase
end

// Update current state on positive edge of clock
always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= STATE_A;  // reset to state A on asynchronous reset
    end else begin
        current_state <= next_state;
    end
end

endmodule