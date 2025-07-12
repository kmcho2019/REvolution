module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

reg [2:0] current_state;
reg [2:0] next_state;

// Define the states
localparam A = 3'b000;
localparam B = 3'b001;
localparam C = 3'b010;
localparam D = 3'b011;
localparam E = 3'b100;
localparam F = 3'b101;

always @(*) begin
    case (current_state)
        A: next_state = w ? A : B;
        B: next_state = w ? D : C;
        C: next_state = w ? D : E;
        D: next_state = w ? A : F;
        E: next_state = w ? D : E;
        F: next_state = w ? D : C;
        default: next_state = A;
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        current_state <= A;
        z <= 1'b0;
    end else begin
        current_state <= next_state;
        case (current_state)
            E: z <= 1'b1;
            F: z <= 1'b1;
            default: z <= 1'b0;
        endcase
    end
end

endmodule