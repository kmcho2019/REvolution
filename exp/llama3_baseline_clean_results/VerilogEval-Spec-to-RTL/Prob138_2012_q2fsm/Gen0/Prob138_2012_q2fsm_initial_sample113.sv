module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

reg [2:0] state;
reg [2:0] next_state;

// Assign state codes
localparam A = 3'b000;
localparam B = 3'b001;
localparam C = 3'b010;
localparam D = 3'b011;
localparam E = 3'b100;
localparam F = 3'b101;

// State flip-flops
always @(posedge clk) begin
    if (reset) begin
        state <= A;
    end else begin
        state <= next_state;
    end
end

// State table
always @(*) begin
    case (state)
        A: next_state = w? B : A;
        B: next_state = w? C : D;
        C: next_state = w? E : D;
        D: next_state = w? F : A;
        E: next_state = w? E : D;
        F: next_state = w? C : D;
        default: next_state = A;
    endcase
end

// Output z
always @(*) begin
    case (state)
        E: z = 1'b1;
        F: z = 1'b1;
        default: z = 1'b0;
    endcase
end

endmodule