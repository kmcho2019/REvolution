module TopModule(
    input  clk,
    input  reset,
    input  w,
    output z
);

reg [2:0] current_state;
reg [2:0] next_state;

// Define state codes
localparam A = 3'b000;
localparam B = 3'b001;
localparam C = 3'b010;
localparam D = 3'b011;
localparam E = 3'b100;
localparam F = 3'b101;

// State transition logic
always @(posedge clk)
begin
    if(reset)
        next_state = A;
    else
    begin
        case(current_state)
            A: next_state = (w) ? B : A;
            B: next_state = (w) ? C : D;
            C: next_state = (w) ? E : D;
            D: next_state = (w) ? F : A;
            E: next_state = (w) ? E : D;
            F: next_state = (w) ? C : D;
            default: next_state = A;
        endcase
    end
end

// Update state flip-flops
always @(posedge clk)
begin
    if(reset)
        current_state <= A;
    else
        current_state <= next_state;
end

// Describe output z
assign z = (current_state == E) || (current_state == F);

endmodule