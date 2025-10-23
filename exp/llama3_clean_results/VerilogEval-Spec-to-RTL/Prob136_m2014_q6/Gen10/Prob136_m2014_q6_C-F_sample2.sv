module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

// Define states as parameters for readability
parameter A = 3'b000;
parameter B = 3'b001;
parameter C = 3'b010;
parameter D = 3'b011;
parameter E = 3'b100;
parameter F = 3'b101;

// State register
reg [2:0] currentState;

// Next state logic using a case statement for efficiency
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

// Output z logic, simplified and separate for clarity
always @(*) begin
    case (1'b1)
        (currentState == E) || (currentState == F): z = 1;
        default: z = 0;
    endcase
end

endmodule