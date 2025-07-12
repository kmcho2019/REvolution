module TopModule(
    input clk,
    input areset,
    input in,
    output out
);

// Define the states
localparam A = 2'b00;
localparam B = 2'b01;
localparam C = 2'b10;
localparam D = 2'b11;

reg [1:0] currentState;

// State transition and output calculation
always @(posedge clk or posedge areset) begin
    if (areset) begin
        // Reset to state A
        currentState <= A;
    end else begin
        case (currentState)
            A: currentState <= in ? B : A;
            B: currentState <= in ? B : C;
            C: currentState <= in ? D : A;
            D: currentState <= in ? B : C;
            default: currentState <= A; // Default to state A
        endcase
    end
end

// Output calculation
always @(currentState) begin
    case (currentState)
        A, B, C: out = 1'b0;
        D: out = 1'b1;
        default: out = 1'b0; // Default output to 0
    endcase
end

endmodule