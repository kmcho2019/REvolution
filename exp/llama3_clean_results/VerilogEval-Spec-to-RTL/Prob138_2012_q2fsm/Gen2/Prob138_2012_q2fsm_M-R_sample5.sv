module TopModule(
    input clk,
    input reset,
    input w,
    output z
);

// Define state codes (one-hot encoding)
parameter A = 6'b000001;
parameter B = 6'b000010;
parameter C = 6'b000100;
parameter D = 6'b001000;
parameter E = 6'b010000;
parameter F = 6'b100000;

// State register
reg [5:0] state;

// State transition logic
always @(posedge clk) begin
    if(reset) begin
        state <= A;
    end else begin
        case(state)
            A: state <= (w == 1'b1) ? B : A;
            B: state <= (w == 1'b1) ? C : D;
            C: state <= (w == 1'b1) ? E : D;
            D: state <= (w == 1'b1) ? F : A;
            E: state <= (w == 1'b1) ? E : D;
            F: state <= (w == 1'b1) ? C : D;
            default: state <= A;
        endcase
    end
end

// Output logic
assign z = (state == E) || (state == F);

endmodule