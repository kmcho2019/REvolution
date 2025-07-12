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
parameter D = 2'b11;

// Current state and next state
reg [1:0] cs, ns;

// State table
always @(*) begin
    case(cs)
        A: begin
            if (r[0] == 1) ns = B;
            else if (r[1] == 1) ns = C;
            else if (r[2] == 1) ns = D;
            else ns = A;
        end
        B: begin
            if (r[0] == 1) ns = B;
            else ns = A;
        end
        C: begin
            if (r[1] == 1) ns = C;
            else ns = A;
        end
        D: begin
            // This state is not actually needed based on the provided state diagram
            // But we keep it here for completeness
            if (r[2] == 1) ns = D;
            else ns = A;
        end
        default: ns = A;
    endcase
end

// State flip-flops
always @(posedge clk) begin
    if (!resetn) cs <= A;
    else cs <= ns;
end

// Outputs
always @(*) begin
    case(cs)
        A: begin
            g[0] = 0;
            g[1] = 0;
            g[2] = 0;
        end
        B: begin
            g[0] = 1;
            g[1] = 0;
            g[2] = 0;
        end
        C: begin
            g[0] = 0;
            g[1] = 1;
            g[2] = 0;
        end
        D: begin
            g[0] = 0;
            g[1] = 0;
            g[2] = 1;
        end
        default: begin
            g[0] = 0;
            g[1] = 0;
            g[2] = 0;
        end
    endcase
end

endmodule