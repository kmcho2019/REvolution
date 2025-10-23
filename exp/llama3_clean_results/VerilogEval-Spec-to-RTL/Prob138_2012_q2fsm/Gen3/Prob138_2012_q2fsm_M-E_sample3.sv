module TopModule(
    input clk,
    input reset,
    input w,
    output z
);

// Define state codes
parameter A = 3'b000;
parameter B = 3'b001;
parameter C = 3'b010;
parameter D = 3'b011;
parameter E = 3'b100;
parameter F = 3'b101;

// State register
reg [2:0] state;
reg [2:0] next_state;

// State transition logic
always @(posedge clk) begin
    if(reset) begin
        state <= A;
    end else begin
        state <= next_state;
    end
end

// Combinational logic for next state
always @(*) begin
    case(state)
        A: next_state = (w == 1'b1) ? B : A;
        B: next_state = (w == 1'b1) ? C : D;
        C: next_state = (w == 1'b1) ? E : D;
        D: next_state = (w == 1'b1) ? F : A;
        E: next_state = (w == 1'b1) ? E : D;
        F: next_state = (w == 1'b1) ? C : D;
        default: next_state = A;
    endcase
end

// Output logic
assign z = (state == E) || (state == F);

endmodule