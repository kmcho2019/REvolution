module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

parameter A = 3'b001;
parameter B = 3'b010;
parameter C = 3'b011;
parameter D = 3'b100;
parameter E = 3'b101;
parameter F = 3'b110;

reg [2:0] currentState;

assign z = (currentState == E) || (currentState == F);

always @(posedge clk) begin
    if (reset) begin
        currentState <= A;
    end else begin
        if (currentState == A) begin
            currentState <= w? A : B;
        end else if (currentState == B) begin
            currentState <= w? D : C;
        end else if (currentState == C) begin
            currentState <= w? D : E;
        end else if (currentState == D) begin
            currentState <= w? A : F;
        end else if (currentState == E) begin
            currentState <= w? D : E;
        end else if (currentState == F) begin
            currentState <= w? D : C;
        end else begin
            currentState <= A;
        end
    end
end

endmodule