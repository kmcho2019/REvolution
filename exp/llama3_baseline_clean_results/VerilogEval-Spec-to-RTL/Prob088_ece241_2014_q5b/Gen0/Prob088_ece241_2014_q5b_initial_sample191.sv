module TopModule(
    input clk,
    input areset,
    input x,
    output z
);

reg [1:0] state, next_state;
parameter A = 2'b10, B = 2'b01;

always @(posedge clk or posedge areset)
begin
    if(areset)
        state <= A;
    else
        state <= next_state;
end

always @(*)
begin
    case(state)
        A:
        begin
            if(x)
                next_state = B;
            else
                next_state = A;
            if(x)
                z = 1'b1;
            else
                z = 1'b0;
        end
        B:
        begin
            next_state = B;
            if(x)
                z = 1'b0;
            else
                z = 1'b1;
        end
        default:
        begin
            next_state = A;
            z = 1'b0;
        end
    endcase
end

endmodule