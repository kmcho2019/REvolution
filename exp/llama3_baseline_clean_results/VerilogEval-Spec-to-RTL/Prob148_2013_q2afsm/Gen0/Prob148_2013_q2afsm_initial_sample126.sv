module TopModule(
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

// State codes
parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;

// State register
reg [1:0] state, next_state;

// State flip-flops
always @(posedge clk or negedge resetn) begin
    if (~resetn) begin
        state <= A;
    end else begin
        state <= next_state;
    end
end

// State table
always @(*) begin
    case (state)
        A: begin
            if (r[0] == 1'b1) begin
                next_state = B;
            end else if (r[1] == 1'b1) begin
                next_state = C;
            end else if (r[2] == 1'b1) begin
                next_state = A;  // No separate state for D, reuse A
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
        default: begin
            next_state = A;
        end
    endcase
end

// Output logic
always @(*) begin
    case (state)
        A: begin
            g[0] = 1'b0;
            g[1] = 1'b0;
            g[2] = 1'b0;
        end
        B: begin
            g[0] = 1'b1;
            g[1] = 1'b0;
            g[2] = 1'b0;
        end
        C: begin
            g[0] = 1'b0;
            g[1] = 1'b1;
            g[2] = 1'b0;
        end
        default: begin
            g[0] = 1'b0;
            g[1] = 1'b0;
            g[2] = 1'b0;
        end
    endcase
end

endmodule