module TopModule(
    input clk,
    input reset,
    input x,
    output reg z
);

parameter [2:0] S0 = 3'b000;
parameter [2:0] S1 = 3'b001;
parameter [2:0] S2 = 3'b010;
parameter [2:0] S3 = 3'b011;
parameter [2:0] S4 = 3'b100;

reg [2:0] y; // current state
reg [2:0] next_y; // next state

// Sequential logic
always @(posedge clk) begin
    if (reset) begin
        y <= S0; // synchronous active high reset
    end else begin
        case (y)
            S0: y <= x ? S1 : S0;
            S1: y <= x ? S4 : S1;
            S2: y <= x ? S1 : S2;
            S3: y <= x ? S2 : S1;
            S4: y <= x ? S4 : S3;
            default: y <= S0;
        endcase
    end
end

// Output z based on current state
always @(*) begin
    case (y)
        S3, S4: z = 1;
        default: z = 0;
    endcase
end

endmodule