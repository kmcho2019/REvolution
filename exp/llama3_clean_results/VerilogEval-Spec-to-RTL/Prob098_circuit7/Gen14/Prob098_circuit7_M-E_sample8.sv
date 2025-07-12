module TopModule(
    input clk,
    input a,
    output reg q
);

reg [1:0] state; // 2 states: 0 (q=0) and 1 (q=1)

always @(posedge clk) begin
    case(state)
        2'b01: // q=1
            if (a == 1'b1) begin
                state <= 2'b00; // Transition to q=0 when a=1
            end else begin
                state <= 2'b01; // Stay in q=1 if a=0
            end
        2'b00: // q=0
            if (a == 1'b0) begin
                state <= 2'b01; // Transition to q=1 when a=0
            end else begin
                state <= 2'b00; // Stay in q=0 if a=1
            end
        default: state <= 2'b01; // Default state is q=1
    endcase
end

always @(*) begin
    case(state)
        2'b01: q = 1'b1;
        2'b00: q = 1'b0;
        default: q = 1'b1; // Default output is q=1
    endcase
end

initial state = 2'b01; // Initialize state to q=1

endmodule