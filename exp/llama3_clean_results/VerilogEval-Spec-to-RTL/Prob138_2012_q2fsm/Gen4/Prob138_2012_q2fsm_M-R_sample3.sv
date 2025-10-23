module TopModule(
    input clk,
    input reset,
    input w,
    output z
);

reg [2:0] current_state;

// State codes
parameter A = 3'b000;
parameter B = 3'b001;
parameter C = 3'b010;
parameter D = 3'b011;
parameter E = 3'b100;
parameter F = 3'b101;

// State flip-flops and state table
always @(posedge clk) begin
    if (reset) begin
        current_state <= A;
    end else begin
        case (current_state)
            A: current_state <= w ? B : A;
            B: current_state <= w ? C : D;
            C: current_state <= w ? E : D;
            D: current_state <= w ? F : A;
            E: current_state <= w ? E : D;
            F: current_state <= w ? C : D;
            default: current_state <= A;
        endcase
    end
end

// Output z
assign z = (current_state == E) || (current_state == F);

endmodule