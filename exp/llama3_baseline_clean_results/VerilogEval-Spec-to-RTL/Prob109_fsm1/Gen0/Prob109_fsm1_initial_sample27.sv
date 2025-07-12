module TopModule (
    input  clk,
    input  areset,
    input  in,
    output out
);

reg [0:0] current_state;
reg [0:0] next_state;

localparam B = 1'b1;
localparam A = 1'b0;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= B;
    end else begin
        current_state <= next_state;
    end
end

always @(*) begin
    case(current_state)
        B: begin
            if (in) begin
                next_state = B;
            end else begin
                next_state = A;
            end
        end
        A: begin
            if (in) begin
                next_state = A;
            end else begin
                next_state = B;
            end
        end
        default: next_state = B;
    endcase
end

assign out = current_state;

endmodule