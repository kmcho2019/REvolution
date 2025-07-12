module TopModule (
    input  logic clk,
    input  logic reset,
    input  logic x,
    output logic z
);

// Define the states
typedef enum logic [2:0] {
    S000 = 3'b000,
    S001 = 3'b001,
    S010 = 3'b010,
    S011 = 3'b011,
    S100 = 3'b100
} state_t;

// Current state
state_t y;

// Next state logic
always_ff @(posedge clk) begin
    if (reset) begin
        y <= S000;
    end else begin
        case (y)
            S000: y <= x ? S001 : S000;
            S001: y <= x ? S100 : S001;
            S010: y <= x ? S001 : S010;
            S011: y <= x ? S010 : S001;
            S100: y <= x ? S100 : S011;
            default: y <= S000;
        endcase
    end
end

// Output logic
always_comb begin
    case (y)
        S000, S001, S010: z = 0;
        S011, S100: z = 1;
        default: z = 0;
    endcase
end

endmodule