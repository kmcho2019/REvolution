module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

// Define states
localparam A = 2'b00;
localparam B = 2'b01;
localparam C = 2'b10;
localparam D = 2'b11;

reg [1:0] current_state;
reg [1:0] next_state;

// Output logic (Moore machine)
always @(current_state) begin
    case (current_state)
        A, B, C: out <= 1'b0;
        D: out <= 1'b1;
        default: out <= 1'b0; // Default to 0 for any unexpected state
    endcase
end

// Sequential logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= A; // Reset to state A
    end else begin
        case (current_state)
            A: current_state <= (in == 1'b0) ? A : B;
            B: current_state <= (in == 1'b0) ? C : B;
            C: current_state <= (in == 1'b0) ? A : D;
            D: current_state <= (in == 1'b0) ? C : B;
            default: current_state <= A; // Default to state A for any unexpected state
        endcase
    end
end

endmodule