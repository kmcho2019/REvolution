module TopModule(
    input  clk,
    input  areset,
    input  x,
    output z
);

reg [1:0] state; // one-hot encoding: A = 2'b01, B = 2'b10
reg [1:0] next_state;

always @(*) begin
    case (state)
        2'b01: begin // state A
            if (x) next_state = 2'b10; // A --x=1--> B
            else next_state = 2'b01; // A --x=0--> A
        end
        2'b10: begin // state B
            next_state = 2'b10; // B --x=0 or x=1--> B
        end
        default: next_state = 2'b01; // reset to A
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) state <= 2'b01; // reset to A
    else state <= next_state;
end

always @(*) begin
    case (state)
        2'b01: z = ~x; // state A, z = 0 if x = 1, z = 1 if x = 0
        2'b10: z = x;  // state B, z = 1 if x = 1, z = 0 if x = 0
        default: z = 1'b0; // default value
    endcase
end

endmodule