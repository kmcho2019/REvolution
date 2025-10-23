module TopModule (
    input  clk,
    input  areset,
    input  x,
    output z
);

reg [1:0] state; // one-hot encoding for states A and B
reg [1:0] next_state;

// output logic
assign z = (state == 2'b01 && x == 1'b1) || (state == 2'b10 && x == 1'b0);

// next state logic
always @(*) begin
    case (state)
        2'b01: begin
            if (x == 1'b0) next_state = 2'b01;
            else next_state = 2'b10;
        end
        2'b10: begin
            next_state = 2'b10; // self-loop
        end
        default: next_state = 2'b01; // default to state A
    endcase
end

// sequential logic
always @(posedge clk or posedge areset) begin
    if (areset) state <= 2'b01; // reset to state A
    else state <= next_state;
end

endmodule