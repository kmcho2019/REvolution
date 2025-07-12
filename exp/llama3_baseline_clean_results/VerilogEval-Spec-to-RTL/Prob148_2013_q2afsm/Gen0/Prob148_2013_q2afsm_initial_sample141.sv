module TopModule(
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

// State encoding
parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;

// State register
reg [1:0] current_state;
reg [1:0] next_state;

// Outputs based on current state
assign g[0] = (current_state == B);
assign g[1] = (current_state == C);
assign g[2] = 1'b0; // No state directly sets g[2] to 1

// State flip-flops
always @(posedge clk) begin
    if (~resetn) begin
        current_state <= A;
    end else begin
        current_state <= next_state;
    end
end

// State table
always @(*) begin
    case (current_state)
        A: begin
            if (r[0] == 1'b1) begin
                next_state = B;
            end else if (r[1] == 1'b1) begin
                next_state = C;
            end else if (r[2] == 1'b1) begin
                next_state = C; // Since D is not used, map r[2] = 1 to C for simplicity
            end else begin
                next_state = A;
            end
        end
        B: begin
            if (r[0] == 1'b1) begin
                next_state = B;
            end else begin
                next_state = A;
            end
        end
        C: begin
            if (r[1] == 1'b1) begin
                next_state = C;
            end else begin
                next_state = A;
            end
        end
        default: next_state = A;
    endcase
end

endmodule