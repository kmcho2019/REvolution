module TopModule(
    input clk,
    input reset,
    input w,
    output z
);

reg [2:0] current_state;
reg [2:0] next_state;

// State encoding
localparam A = 3'b000;
localparam B = 3'b001;
localparam C = 3'b010;
localparam D = 3'b011;
localparam E = 3'b100;
localparam F = 3'b101;

// Combinational logic to determine next state
always @(*)
begin
    case(current_state)
        A: next_state = (w == 1'b0) ? B : A;
        B: next_state = (w == 1'b0) ? C : D;
        C: next_state = (w == 1'b0) ? E : D;
        D: next_state = (w == 1'b0) ? F : A;
        E: next_state = (w == 1'b1) ? E : D;
        F: next_state = (w == 1'b1) ? C : D;
        default: next_state = A;
    endcase
end

// Sequential logic to update current state
always @(posedge clk or posedge reset)
begin
    if(reset)
        current_state <= A;
    else
        current_state <= next_state;
end

// Combinational logic to determine output z
always @(*)
begin
    case(current_state)
        A: z = 1'b0;
        B: z = 1'b0;
        C: z = 1'b0;
        D: z = 1'b0;
        E: z = 1'b1;
        F: z = 1'b1;
        default: z = 1'b0;
    endcase
end

endmodule