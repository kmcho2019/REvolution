module TopModule(
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

// Define the states
reg [1:0] current_state;
reg [1:0] next_state;

// Define the state codes
parameter STATE_A = 2'b00;
parameter STATE_B = 2'b01;
parameter STATE_C = 2'b10;
parameter STATE_D = 2'b11;

// Continuous assignment for the output signals
assign g[0] = (current_state == STATE_B);
assign g[1] = (current_state == STATE_C);
assign g[2] = (current_state == STATE_D);

// State table
always @(current_state, r) begin
    case (current_state)
        STATE_A: begin
            if (r[0] == 1'b1) begin
                next_state = STATE_B;
            end else if (r[1] == 1'b1) begin
                next_state = STATE_C;
            end else if (r[2] == 1'b1) begin
                next_state = STATE_D;
            end else begin
                next_state = STATE_A;
            end
        end
        STATE_B: begin
            if (r[0] == 1'b1) begin
                next_state = STATE_B;
            end else begin
                next_state = STATE_A;
            end
        end
        STATE_C: begin
            if (r[1] == 1'b1) begin
                next_state = STATE_C;
            end else begin
                next_state = STATE_A;
            end
        end
        STATE_D: begin
            // Since device 2 has the lowest priority, it will only receive a grant if it is the only device making a request
            if (r[2] == 1'b1 && r[0] == 1'b0 && r[1] == 1'b0) begin
                next_state = STATE_D;
            end else begin
                next_state = STATE_A;
            end
        end
        default: next_state = STATE_A;
    endcase
end

// State flip-flops
always @(posedge clk) begin
    if (~resetn) begin
        current_state <= STATE_A;
    end else begin
        current_state <= next_state;
    end
end

endmodule