module TopModule(
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

reg [1:0] current_state;
reg [1:0] next_state;

// State codes
localparam A = 2'b00;
localparam B = 2'b01;
localparam C = 2'b10;
localparam D = 2'b11;

// State flip-flops
always @(posedge clk) begin
    if (~resetn) begin
        current_state <= A;
    end else begin
        current_state <= next_state;
    end
end

// Next state logic
always @(*) begin
    case (current_state)
        A: begin
            if (r[0]) begin
                next_state = B;
            end else if (r[1]) begin
                next_state = C;
            end else if (r[2]) begin
                next_state = D;
            end else begin
                next_state = A;
            end
        end
        B: begin
            if (r[0]) begin
                next_state = B;
            end else begin
                next_state = A;
            end
        end
        C: begin
            if (r[1]) begin
                next_state = C;
            end else begin
                next_state = A;
            end
        end
        D: begin
            next_state = A;  // This state is not used in the original FSM description
        end
        default: next_state = A;
    endcase
end

// Outputs
assign g[0] = (current_state == B) ? 1'b1 : 1'b0;
assign g[1] = (current_state == C) ? 1'b1 : 1'b0;
assign g[2] = 1'b0;  // This output is not used in the original FSM description

endmodule