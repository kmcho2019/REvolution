module TopModule (
    input        clk,
    input        resetn,
    input  [2:0] r,
    output [2:0] g
);

// Define state codes
parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;

// Define state register
reg [1:0] state;
reg [1:0] next_state;

// State table
always @(*) begin
    case (state)
        A: begin
            if (r[0] == 1) begin
                next_state = B;
            end else if (r[1] == 1 && r[0] == 0) begin
                next_state = C;
            end else if (r[2] == 1 && r[0] == 0 && r[1] == 0) begin
                next_state = A; // In this case, we should actually ignore this condition and stay in A
            end else begin
                next_state = A;
            end
        end
        B: begin
            if (r[0] == 1) begin
                next_state = B;
            end else begin
                next_state = A;
            end
        end
        C: begin
            if (r[1] == 1) begin
                next_state = C;
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
        state <= A;
    end else begin
        state <= next_state;
    end
end

// Assign output signals
assign g[0] = (state == B);
assign g[1] = (state == C);
assign g[2] = 1'b0; // We never reach state D in this implementation
endmodule