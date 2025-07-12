module TopModule(
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

// Define state codes
parameter A = 4'b0000;
parameter B = 4'b0001;
parameter C = 4'b0010;
parameter D = 4'b0011;

// Current state and next state
reg [3:0] current_state;
reg [3:0] next_state;

// Continuous assignment for output signals
assign g[0] = (current_state == B)? 1'b1 : 1'b0;
assign g[1] = (current_state == C)? 1'b1 : 1'b0;
assign g[2] = (current_state == D)? 1'b1 : 1'b0;

// State table
always @(*) begin
    case (current_state)
        A: begin
            if (r[0] == 1'b1) begin
                next_state = B;
            end else if (r[1] == 1'b1) begin
                next_state = C;
            end else if (r[2] == 1'b1) begin
                next_state = D;
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
        D: begin
            // Since device 2 has the lowest priority, if either device 0 or 1 requests, it should go back to A
            if (r[0] == 1'b1 || r[1] == 1'b1) begin
                next_state = A;
            end else if (r[2] == 1'b1) begin
                next_state = D;
            end else begin
                next_state = A;
            end
        end
        default: next_state = A;
    endcase
end

// State flip-flops
always @(posedge clk) begin
    if (~resetn) begin
        current_state <= A;
    end else begin
        current_state <= next_state;
    end
end

endmodule