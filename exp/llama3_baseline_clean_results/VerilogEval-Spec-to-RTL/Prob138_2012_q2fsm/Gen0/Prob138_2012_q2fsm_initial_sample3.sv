module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

// Define states
parameter A = 4'd0, B = 4'd1, C = 4'd2, D = 4'd3, E = 4'd4, F = 4'd5;

// State register
reg [3:0] state, next_state;

// State flip-flops
always @(posedge clk) begin
    if(reset) begin
        state <= A;
    end else begin
        state <= next_state;
    end
end

// State table
always @(*) begin
    case(state)
        A: if(w) next_state = B; else next_state = A;
        B: if(w) next_state = C; else next_state = D;
        C: if(w) next_state = E; else next_state = D;
        D: if(w) next_state = F; else next_state = A;
        E: if(w) next_state = E; else next_state = D;
        F: if(w) next_state = C; else next_state = D;
        default: next_state = A;
    endcase
end

// Output logic
assign z = (state == E || state == F);
endmodule