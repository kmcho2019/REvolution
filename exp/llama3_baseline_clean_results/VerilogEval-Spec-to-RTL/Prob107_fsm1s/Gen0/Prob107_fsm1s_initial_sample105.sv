module TopModule (
    input  clk,
    input  reset,
    input  in,
    output out
);

reg [0:0] current_state;
reg [0:0] next_state;

parameter A = 1'b0;
parameter B = 1'b1;

always @(*) begin
    case (current_state)
        A: begin
            if (!in) 
                next_state = B;
            else 
                next_state = A;
        end
        B: begin
            if (!in) 
                next_state = A;
            else 
                next_state = B;
        end
        default: next_state = B;
    endcase
end

always @(posedge clk) begin
    if (reset) 
        current_state <= B;
    else 
        current_state <= next_state;
end

assign out = (current_state == B) ? 1'b1 : 1'b0;

initial current_state = B;

endmodule