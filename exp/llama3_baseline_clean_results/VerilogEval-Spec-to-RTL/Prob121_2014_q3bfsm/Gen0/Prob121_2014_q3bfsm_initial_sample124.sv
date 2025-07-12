module TopModule(
    input clk,
    input reset,
    input x,
    output reg z
);

// Define the states
typedef enum logic [2:0] {
    S000,
    S001,
    S010,
    S011,
    S100,
    S101,
    S110,
    S111
} state_t;

// Current state register
reg [2:0] current_state;
reg [2:0] next_state;

// Output register
always @(posedge clk) begin
    if (reset) begin
        current_state <= S000;
        z <= 0;
    end else begin
        current_state <= next_state;
        case (current_state)
            S000: z <= 0;
            S001: z <= 0;
            S010: z <= 0;
            S011: z <= 1;
            S100: z <= 1;
            default: z <= 0;
        endcase
    end
end

// Next state logic
always @(*) begin
    case (current_state)
        S000: next_state = (x) ? S001 : S000;
        S001: next_state = (x) ? S100 : S001;
        S010: next_state = (x) ? S001 : S010;
        S011: next_state = (x) ? S010 : S001;
        S100: next_state = (x) ? S100 : S011;
        default: next_state = S000;
    endcase
end

endmodule