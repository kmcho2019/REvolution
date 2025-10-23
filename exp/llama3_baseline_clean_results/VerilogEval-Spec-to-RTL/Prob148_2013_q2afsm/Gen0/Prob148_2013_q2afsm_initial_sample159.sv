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
parameter D = 2'b11;

// State register
reg [1:0] state;
reg [1:0] next_state;

// State flip-flops
always @(posedge clk) begin
    if (!resetn) begin
        state <= A;
    end else begin
        state <= next_state;
    end
end

// State table
always @(*) begin
    case (state)
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
            // No need to handle D state as per the state diagram
            // Assuming the FSM will only go to D state when r[0] = 0, r[1] = 0, r[2] = 1
            // and will stay in D state until r[2] = 0
            if (r[2]) begin
                next_state = D;
            end else begin
                next_state = A;
            end
        end
    endcase
end

// Output logic
assign g[0] = (state == B);
assign g[1] = (state == C);
assign g[2] = (state == D);

endmodule