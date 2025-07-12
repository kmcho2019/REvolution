module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

reg [2:0] state;
reg [2:0] next_state;

always @(state or w) begin
    case(state)
        0: next_state = (w) ? 1 : 0; // A
        1: next_state = (w) ? 2 : 3; // B
        2: next_state = (w) ? 4 : 3; // C
        3: next_state = (w) ? 5 : 0; // D
        4: next_state = (w) ? 4 : 3; // E
        5: next_state = (w) ? 2 : 3; // F
        default: next_state = 0; // default state
    endcase
end

always @(posedge clk) begin
    if(reset) begin
        state <= 0;
    end else begin
        state <= next_state;
    end
end

always @(state) begin
    case(state)
        0: z = 0; // A
        1: z = 0; // B
        2: z = 0; // C
        3: z = 0; // D
        4: z = 1; // E
        5: z = 1; // F
        default: z = 0; // default output
    endcase
end

endmodule