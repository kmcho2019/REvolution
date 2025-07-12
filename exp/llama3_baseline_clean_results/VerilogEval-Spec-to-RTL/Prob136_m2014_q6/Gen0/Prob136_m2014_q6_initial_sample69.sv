module TopModule(
    input  clk,
    input  reset,
    input  w,
    output z
);

parameter A = 6'b000000;
parameter B = 6'b000001;
parameter C = 6'b000010;
parameter D = 6'b000011;
parameter E = 6'b000100;
parameter F = 6'b000101;

reg [5:0] current_state;
reg [5:0] next_state;

always @(*) begin
    case(current_state)
        A: next_state = (w) ? A : B;
        B: next_state = (w) ? D : C;
        C: next_state = (w) ? D : E;
        D: next_state = (w) ? A : F;
        E: next_state = (w) ? D : E;
        F: next_state = (w) ? D : C;
        default: next_state = A;
    endcase
end

always @(posedge clk or posedge reset) begin
    if(reset) begin
        current_state <= A;
    end else begin
        current_state <= next_state;
    end
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