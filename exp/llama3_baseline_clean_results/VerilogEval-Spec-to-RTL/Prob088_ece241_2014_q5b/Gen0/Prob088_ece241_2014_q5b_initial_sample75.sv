module TopModule(
    input  clk,
    input  areset,
    input  x,
    output z
);

reg [1:0] state;
reg [1:0] next_state;

// Output logic
always @(*) begin
    case(state)
        2'b01: z = ~x; // State A
        2'b10: z = ~x || x; // State B
        default: z = 1'b0;
    endcase
end

// Next state logic
always @(*) begin
    case(state)
        2'b01: next_state = x? 2'b10 : 2'b01;
        2'b10: next_state = 2'b10;
        default: next_state = 2'b01;
    endcase
end

// State register
always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= 2'b01;
    end else begin
        state <= next_state;
    end
end

endmodule