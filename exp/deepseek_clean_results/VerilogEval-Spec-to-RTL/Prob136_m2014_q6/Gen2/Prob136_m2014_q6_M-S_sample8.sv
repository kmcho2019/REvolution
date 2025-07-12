module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

// Define states
parameter A = 3'b000;
parameter B = 3'b001;
parameter C = 3'b010;
parameter D = 3'b011;
parameter E = 3'b100;
parameter F = 3'b101;

reg [2:0] state;

// Combined state transition and output logic
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
        endcase
    end
end

// Output depends only on current state
assign z = (state == E) | (state == F);

endmodule