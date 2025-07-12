module TopModule(
    input  clk,
    input  reset,
    input  w,
    output z
);

// State codes
parameter A = 3'b000;
parameter B = 3'b001;
parameter C = 3'b010;
parameter D = 3'b011;
parameter E = 3'b100;
parameter F = 3'b101;

// Internal state signal
reg [2:0] current_state;

// State A module
module StateA(
    input  w,
    input  [2:0] current_state,
    output reg [2:0] next_state
);
    always @(*) begin
        if(w)
            next_state = B;
        else
            next_state = A;
    end
endmodule

// State B module
module StateB(
    input  w,
    input  [2:0] current_state,
    output reg [2:0] next_state
);
    always @(*) begin
        if(w)
            next_state = C;
        else
            next_state = D;
    end
endmodule

// State C module
module StateC(
    input  w,
    input  [2:0] current_state,
    output reg [2:0] next_state
);
    always @(*) begin
        if(w)
            next_state = E;
        else
            next_state = D;
    end
endmodule

// State D module
module StateD(
    input  w,
    input  [2:0] current_state,
    output reg [2:0] next_state
);
    always @(*) begin
        if(w)
            next_state = F;
        else
            next_state = A;
    end
endmodule

// State E module
module StateE(
    input  w,
    input  [2:0] current_state,
    output reg [2:0] next_state
);
    always @(*) begin
        if(w)
            next_state = E;
        else
            next_state = D;
    end
endmodule

// State F module
module StateF(
    input  w,
    input  [2:0] current_state,
    output reg [2:0] next_state
);
    always @(*) begin
        if(w)
            next_state = C;
        else
            next_state = D;
    end
endmodule

// Instantiate state modules
wire [2:0] next_state_A;
wire [2:0] next_state_B;
wire [2:0] next_state_C;
wire [2:0] next_state_D;
wire [2:0] next_state_E;
wire [2:0] next_state_F;

StateA state_a_module(w, current_state, next_state_A);
StateB state_b_module(w, current_state, next_state_B);
StateC state_c_module(w, current_state, next_state_C);
StateD state_d_module(w, current_state, next_state_D);
StateE state_e_module(w, current_state, next_state_E);
StateF state_f_module(w, current_state, next_state_F);

// State flip-flops
always @(posedge clk)
begin
    if(reset)
        current_state <= A;
    else
    begin
        case(current_state)
            A: current_state <= next_state_A;
            B: current_state <= next_state_B;
            C: current_state <= next_state_C;
            D: current_state <= next_state_D;
            E: current_state <= next_state_E;
            F: current_state <= next_state_F;
            default: current_state <= A;
        endcase
    end
end

// Output z
assign z = (current_state == E || current_state == F);

endmodule