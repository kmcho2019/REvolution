module TopModule(
    input  clk,
    input  reset,
    input  w,
    output z
);

// State encoding
localparam A = 3'b000;
localparam B = 3'b001;
localparam C = 3'b010;
localparam D = 3'b011;
localparam E = 3'b100;
localparam F = 3'b101;

// Internal state signal
reg [2:0] current_state;

// State flip-flops and state table
always @ (posedge clk) begin
    if (reset) begin
        current_state <= A; // Reset to state A
    end else begin
        case (current_state)
            A: current_state <= (w) ? B : A;
            B: current_state <= (w) ? C : D;
            C: current_state <= (w) ? E : D;
            D: current_state <= (w) ? F : A;
            E: current_state <= (w) ? E : D;
            F: current_state <= (w) ? C : D;
            default: current_state <= A; // Default to state A
        endcase
    end
end

// FSM output
assign z = (current_state == E) || (current_state == F);

endmodule