module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg [1:0] current_state;
reg [1:0] next_state;

// One-hot encoding for states
localparam STATE_A = 2'b01;
localparam STATE_B = 2'b10;

// Combinational logic to generate next state and output z
always @(*) begin
    case (current_state)
        STATE_A: begin
            if (~x) begin
                next_state = STATE_A;
                z = 1'b0;
            end else begin
                next_state = STATE_B;
                z = 1'b1;
            end
        end
        STATE_B: begin
            next_state = STATE_B;
            z = ~x;
        end
        default: begin
            next_state = STATE_A;
            z = 1'b0;
        end
    endcase
end

// Sequential logic to update current state
always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= STATE_A;
    end else begin
        current_state <= next_state;
    end
end

endmodule