module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

// Define the states as parameters using one-hot encoding
parameter A = 6'b000001;
parameter B = 6'b000010;
parameter C = 6'b000100;
parameter D = 6'b001000;
parameter E = 6'b010000;
parameter F = 6'b100000;

// Define the state register using one-hot encoding
reg [5:0] state;
reg [5:0] next_state;

// Combinational logic to determine the next state
always @(*) begin
    case (state)
        A: next_state = w? A : B;
        B: next_state = w? D : C;
        C: next_state = w? D : E;
        D: next_state = w? A : F;
        E: next_state = w? D : E;
        F: next_state = w? D : C;
        default: next_state = A;
    endcase
end

// Alternatively, use a combination of multiplexers and logic gates
// wire [5:0] next_state_mux;
// assign next_state_mux = (state == A)? (w? A : B) : 
//                         (state == B)? (w? D : C) : 
//                         (state == C)? (w? D : E) : 
//                         (state == D)? (w? A : F) : 
//                         (state == E)? (w? D : E) : 
//                         (state == F)? (w? D : C) : A;
// assign next_state = next_state_mux;

// Combinational logic for output z
assign z = (state == E) || (state == F);

// Update the state on the positive edge of the clock
always @(posedge clk) begin
    if (reset) state <= A;
    else state <= next_state;
end

// Add optimization attributes
// (* area_opt = "yes" *)
// (* power_opt = "yes" *)
// (* clock_enable = "clk" *)
// (* clock_disable = "reset" *)

endmodule