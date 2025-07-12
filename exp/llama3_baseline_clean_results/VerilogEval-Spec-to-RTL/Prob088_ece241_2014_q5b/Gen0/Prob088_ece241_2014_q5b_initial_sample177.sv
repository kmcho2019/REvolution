module TopModule(
    input  clk,
    input  areset,
    input  x,
    output z
);

reg [1:0] state;
reg [1:0] next_state;

// One-hot encoding: A = 2'b01, B = 2'b10
localparam A = 2'b01;
localparam B = 2'b10;

always @(*) begin
    case (state)
        A: begin
            if (x == 0) begin
                next_state = A;
                z = 0;
            end else begin
                next_state = B;
                z = 1;
            end
        end
        B: begin
            next_state = B;
            if (x == 0) begin
                z = 1;
            end else begin
                z = 0;
            end
        end
        default: begin
            next_state = A;
            z = 0;
        end
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= A;
    end else begin
        state <= next_state;
    end
end

endmodule