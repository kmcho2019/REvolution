module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

// Define states as constants
localparam A = 3'b000;
localparam B = 3'b001;
localparam C = 3'b010;
localparam D = 3'b011;
localparam E = 3'b100;
localparam F = 3'b101;

reg [2:0] state, next_state;

// Sequential logic
always @(posedge clk) begin
    if (reset) state <= A;
    else state <= next_state;
end

// Combinational logic for next state and output z
always @(*) begin
    case (state)
        A: begin
            z = 0;
            if (w == 1) next_state = A; else next_state = B;
        end
        B: begin
            z = 0;
            if (w == 1) next_state = D; else next_state = C;
        end
        C: begin
            z = 0;
            if (w == 1) next_state = D; else next_state = E;
        end
        D: begin
            z = 0;
            if (w == 1) next_state = A; else next_state = F;
        end
        E: begin
            z = 1;
            if (w == 1) next_state = D; else next_state = E;
        end
        F: begin
            z = 1;
            if (w == 1) next_state = D; else next_state = C;
        end
        default: begin
            z = 0;
            next_state = A;
        end
    endcase
end

endmodule