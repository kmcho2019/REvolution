module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

// Define the states as parameters using Gray code encoding
parameter A = 3'b000;
parameter B = 3'b001;
parameter C = 3'b011;
parameter D = 3'b010;
parameter E = 3'b110;
parameter F = 3'b111;

// State register
reg [2:0] currentState;

// Next state logic
always @(posedge clk) begin
    if (reset) begin
        currentState <= A;
    end else begin
        case (currentState)
            A: currentState <= w ? A : B;
            B: currentState <= w ? D : C;
            C: currentState <= w ? D : E;
            D: currentState <= w ? A : F;
            E: currentState <= w ? D : E;
            F: currentState <= w ? D : C;
            default: currentState <= A;
        endcase
    end
end

// Output z logic
always @(*) begin
    z = (currentState == E) || (currentState == F);
end

endmodule