module TopModule(
    input clk,
    input reset,
    input w,
    output z
);

reg [2:0] current_state;
reg [2:0] next_state;

// Define states
parameter A = 3'b000;
parameter B = 3'b001;
parameter C = 3'b010;
parameter D = 3'b011;
parameter E = 3'b100;
parameter F = 3'b101;

// Next state logic
always @(*) begin
    case(current_state)
        A: next_state = (w == 1'b0) ? B : A;
        B: next_state = (w == 1'b0) ? C : D;
        C: next_state = (w == 1'b0) ? E : D;
        D: next_state = (w == 1'b0) ? F : A;
        E: next_state = (w == 1'b0) ? E : D;
        F: next_state = (w == 1'b0) ? C : D;
        default: next_state = A;
    endcase
end

// Output logic
assign z = (current_state == E) || (current_state == F);

// Sequential logic
always @(posedge clk) begin
    if(reset) begin
        current_state <= A;
    end else begin
        current_state <= next_state;
    end
end

endmodule