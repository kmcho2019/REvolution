module TopModule(
    input clk,
    input reset,
    input w,
    output z
);

// State codes (one-hot encoding)
reg [5:0] current_state;
reg [5:0] next_state;

// State codes
parameter A = 6'b000001;
parameter B = 6'b000010;
parameter C = 6'b000100;
parameter D = 6'b001000;
parameter E = 6'b010000;
parameter F = 6'b100000;

// State table and state flip-flops
always @(posedge clk)
begin
    if(reset)
        current_state <= A;
    else
    begin
        case(current_state)
            A: current_state <= w ? B : A;
            B: current_state <= w ? C : D;
            C: current_state <= w ? E : D;
            D: current_state <= w ? F : A;
            E: current_state <= w ? E : D;
            F: current_state <= w ? C : D;
            default: current_state <= A;
        endcase
    end
end

// FSM output
assign z = (current_state == E) || (current_state == F);

endmodule