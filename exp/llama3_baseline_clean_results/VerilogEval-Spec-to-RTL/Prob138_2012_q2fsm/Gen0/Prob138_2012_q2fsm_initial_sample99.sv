module TopModule(
    input clk,
    input reset,
    input w,
    output z
);

// State codes
parameter A = 3'b000;
parameter B = 3'b001;
parameter C = 3'b010;
parameter D = 3'b011;
parameter E = 3'b100;
parameter F = 3'b101;

// Current state and next state
reg [2:0] current_state;
reg [2:0] next_state;

// State table
always @(*) begin
    case(current_state)
        A: begin
            if (w) next_state = B;
            else next_state = A;
        end
        B: begin
            if (w) next_state = C;
            else next_state = D;
        end
        C: begin
            if (w) next_state = E;
            else next_state = D;
        end
        D: begin
            if (w) next_state = F;
            else next_state = A;
        end
        E: begin
            if (w) next_state = E;
            else next_state = D;
        end
        F: begin
            if (w) next_state = C;
            else next_state = D;
        end
        default: next_state = A;
    endcase
end

// State flip-flops
always @(posedge clk) begin
    if (reset) current_state <= A;
    else current_state <= next_state;
end

// Output z
always @(*) begin
    case(current_state)
        E: z = 1'b1;
        F: z = 1'b1;
        default: z = 1'b0;
    endcase
end

endmodule