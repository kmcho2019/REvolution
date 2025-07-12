module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

reg [2:0] current_state, next_state;

// State encoding
localparam A = 3'b000;
localparam B = 3'b001;
localparam C = 3'b010;
localparam D = 3'b011;
localparam E = 3'b100;
localparam F = 3'b101;

always @(*) begin
    case(current_state)
        A: 
            if(w) 
                next_state = A;
            else 
                next_state = B;
        B: 
            if(w) 
                next_state = D;
            else 
                next_state = C;
        C: 
            if(w) 
                next_state = D;
            else 
                next_state = E;
        D: 
            if(w) 
                next_state = A;
            else 
                next_state = F;
        E: 
            if(w) 
                next_state = D;
            else 
                next_state = E;
        F: 
            if(w) 
                next_state = D;
            else 
                next_state = C;
        default: 
            next_state = A;
    endcase
end

always @(posedge clk or posedge reset) begin
    if(reset) 
        current_state <= A;
    else 
        current_state <= next_state;
end

always @(*) begin
    case(current_state)
        A: z = 0;
        B: z = 0;
        C: z = 0;
        D: z = 0;
        E: z = 1;
        F: z = 1;
        default: z = 0;
    endcase
end

endmodule