module TopModule(
    input  clk,
    input  reset,
    input  in,
    output out
);

// Define the states
localparam A = 2'd0;
localparam B = 2'd1;
localparam C = 2'd2;
localparam D = 2'd3;

// Current state register
reg [1:0] state;

// Next state logic
always @(posedge clk) begin
    if (reset) begin
        // Reset to state A
        state <= A;
    end else begin
        case (state)
            A: state <= in ? B : A;
            B: state <= in ? B : C;
            C: state <= in ? D : A;
            D: state <= in ? B : C;
            default: state <= A;
        endcase
    end
end

// Output logic (Moore machine, output depends on current state)
always @(state) begin
    case (state)
        A, B, C: out <= 1'd0;
        D: out <= 1'd1;
        default: out <= 1'd0;
    endcase
end

endmodule