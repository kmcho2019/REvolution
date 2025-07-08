module TopModule (
    input clk,
    input reset,
    input w,
    output reg z
);

// State encoding
localparam A = 3'd0;
localparam B = 3'd1;
localparam C = 3'd2;
localparam D = 3'd3;
localparam E = 3'd4;
localparam F = 3'd5;

reg [2:0] state, next_state;

always @(posedge clk) begin
    if (reset)
        state <= A;
    else
        state <= next_state;
end

// Next state logic
always @(*) begin
    case (state)
        A: begin
            if (w == 1'b0)
                next_state = B;
            else
                next_state = A;
        end
        B: begin
            if (w == 1'b0)
                next_state = C;
            else
                next_state = D;
        end
        C: begin
            if (w == 1'b0)
                next_state = E;
            else
                next_state = D;
        end
        D: begin
            if (w == 1'b0)
                next_state = F;
            else
                next_state = A;
        end
        E: begin
            // The transition depends on input z=1
            // But the diagram states "E (1)" meaning w=1?
            // Actually transitions are labeled with the input w.
            // The problem states: "E (1) --0--> E" and "E (1) --1--> D"
            // The "(1)" indicates output z=1 in E and F states.
            // The transitions are still labeled with w.
            // So from E, if w=0 -> E, if w=1 -> D
            if (w == 1'b0)
                next_state = E;
            else
                next_state = D;
        end
        F: begin
            if (w == 1'b0)
                next_state = C;
            else
                next_state = D;
        end
        default: next_state = A;
    endcase
end

// Output logic: According to the diagram, z=1 only in E and F states (the notation "E (1)" means output z=1 in state E)
always @(*) begin
    case (state)
        E, F: z = 1'b1;
        default: z = 1'b0;
    endcase
end

endmodule