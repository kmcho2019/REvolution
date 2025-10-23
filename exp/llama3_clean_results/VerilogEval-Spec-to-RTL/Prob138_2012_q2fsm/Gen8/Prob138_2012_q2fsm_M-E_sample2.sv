module TopModule(
    input  clk,
    input  reset,
    input  w,
    output z
);

reg [2:0] state;
reg [2:0] next_state;

// State encoding (Gray code)
localparam A = 3'b000;
localparam B = 3'b001;
localparam C = 3'b011;
localparam D = 3'b010;
localparam E = 3'b110;
localparam F = 3'b111;

// Next-state LUT (ROM)
reg [2:0] next_state_lut [6];

always @ (*) begin
    case (state)
        A:
            next_state_lut[0] = w? B : A;
        B:
            next_state_lut[1] = w? C : D;
        C:
            next_state_lut[2] = w? E : D;
        D:
            next_state_lut[3] = w? F : A;
        E:
            next_state_lut[4] = w? E : D;
        F:
            next_state_lut[5] = w? C : D;
        default:
            next_state_lut[0] = A; // Default to state A
    endcase
end

// Output LUT (ROM)
reg [0:0] output_lut [6];

always @ (*) begin
    case (state)
        A:
            output_lut[0] = 1'b0;
        B:
            output_lut[1] = 1'b0;
        C:
            output_lut[2] = 1'b0;
        D:
            output_lut[3] = 1'b0;
        E:
            output_lut[4] = 1'b1;
        F:
            output_lut[5] = 1'b1;
        default:
            output_lut[0] = 1'b0; // Default to 0
    endcase
end

// State flip-flops
always @ (posedge clk) begin
    if (reset) begin
        state <= A; // Reset to state A
    end else begin
        state <= next_state_lut[state];
    end
end

// Output z
assign z = output_lut[state];

endmodule