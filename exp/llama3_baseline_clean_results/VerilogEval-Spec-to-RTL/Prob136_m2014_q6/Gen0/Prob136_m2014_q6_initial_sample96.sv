module TopModule(
    input clk,
    input reset,
    input w,
    output z
);

reg [2:0] state, nextState;

// State encoding
localparam A = 3'b000;
localparam B = 3'b001;
localparam C = 3'b010;
localparam D = 3'b011;
localparam E = 3'b100;
localparam F = 3'b101;

always @(posedge clk or posedge reset)
begin
    if (reset)
        state <= A;
    else
        state <= nextState;
end

always @(*)
begin
    case (state)
        A: 
            if (~w)
                nextState = B;
            else 
                nextState = A;
        B: 
            if (~w)
                nextState = C;
            else 
                nextState = D;
        C: 
            if (~w)
                nextState = E;
            else 
                nextState = D;
        D: 
            if (~w)
                nextState = F;
            else 
                nextState = A;
        E: 
            if (~w)
                nextState = E;
            else 
                nextState = D;
        F: 
            if (~w)
                nextState = C;
            else 
                nextState = D;
        default:
            nextState = A;
    endcase
end

// Determining output z
assign z = (state == E || state == F);

endmodule