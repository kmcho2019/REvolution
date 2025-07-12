module TopModule (
    input clk,
    input reset,
    input w,
    output reg z
);

// Define states
parameter A = 3'b000;
parameter B = 3'b001;
parameter C = 3'b010;
parameter D = 3'b011;
parameter E = 3'b100;
parameter F = 3'b101;

reg [2:0] state;

// Combined state transition and output logic
always @(posedge clk) begin
    if (reset) begin
        state <= A;
        z <= 0;
    end
    else begin
        case (state)
            A: begin
                z <= 0;
                state <= w ? A : B;
            end
            B: begin
                z <= 0;
                state <= w ? D : C;
            end
            C: begin
                z <= 0;
                state <= w ? D : E;
            end
            D: begin
                z <= 0;
                state <= w ? A : F;
            end
            E: begin
                z <= 1;
                state <= w ? D : E;
            end
            F: begin
                z <= 1;
                state <= w ? D : C;
            end
            default: begin
                z <= 0;
                state <= A;
            end
        endcase
    end
end

endmodule