module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

// Define states
localparam STATE_A = 2'b00;
localparam STATE_B = 2'b01;
localparam STATE_C = 2'b10;
localparam STATE_D = 2'b11;

reg [1:0] current_state, next_state;

// State transition logic (combinational)
always @(*) begin
    case (current_state)
        STATE_A: begin
            if (r[0]) next_state = STATE_B;
            else if (r[1]) next_state = STATE_C;
            else if (r[2]) next_state = STATE_D;
            else next_state = STATE_A;
        end
        STATE_B: begin
            if (r[0]) next_state = STATE_B;
            else next_state = STATE_A;
        end
        STATE_C: begin
            if (r[1]) next_state = STATE_C;
            else next_state = STATE_A;
        end
        STATE_D: begin
            next_state = STATE_A;  // From description, D only transitions back to A
        end
        default: next_state = STATE_A;
    endcase
end

// State storage (sequential)
always @(posedge clk) begin
    if (!resetn)
        current_state <= STATE_A;
    else
        current_state <= next_state;
end

// Output logic (continuous assignments)
assign g[0] = (current_state == STATE_B);
assign g[1] = (current_state == STATE_C);
assign g[2] = (current_state == STATE_D);

endmodule