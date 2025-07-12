module TopModule(
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

// Define state codes
parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;
parameter D = 2'b11;

// Define state signal
reg [1:0] state;
reg [1:0] next_state;

// State flip-flops
always @ (posedge clk) begin
    if (~resetn) begin
        state <= A;
    end else begin
        state <= next_state;
    end
end

// State table
always @ (*) begin
    case (state)
        A: begin
            if (r[0] == 1'b1) begin
                next_state <= B;
            end else if (r[1] == 1'b1) begin
                next_state <= C;
            end else if (r[2] == 1'b1) begin
                next_state <= D; // Note: This transition is not needed according to the problem description, but added for completeness
            end else begin
                next_state <= A;
            end
        end
        B: begin
            if (r[0] == 1'b1) begin
                next_state <= B;
            end else begin
                next_state <= A;
            end
        end
        C: begin
            if (r[1] == 1'b1) begin
                next_state <= C;
            end else begin
                next_state <= A;
            end
        end
        D: begin
            // Note: This state is not needed according to the problem description, but added for completeness
            next_state <= A;
        end
        default: begin
            next_state <= A;
        end
    endcase
end

// Continuous assignment for output signals
assign g[0] = (state == B);
assign g[1] = (state == C);
assign g[2] = 1'b0; // Output g[2] is always 0 according to the problem description

endmodule