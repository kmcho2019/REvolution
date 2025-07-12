module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

// State encoding (binary)
localparam A = 3'b000;
localparam B = 3'b001;
localparam C = 3'b010;
localparam D = 3'b011;
localparam E = 3'b100;
localparam F = 3'b101;

reg [2:0] state;

// State transition and register
always @(posedge clk) begin
    if (reset)
        state <= A;
    else begin
        case (state)
            A: state <= w ? A : B;
            B: state <= w ? D : C;
            C: state <= w ? D : E;
            D: state <= w ? A : F;
            E: state <= w ? D : E;
            F: state <= w ? D : C;
            default: state <= A;
        endcase
    end
end

// Output logic
assign z = (state == E) | (state == F);

endmodule