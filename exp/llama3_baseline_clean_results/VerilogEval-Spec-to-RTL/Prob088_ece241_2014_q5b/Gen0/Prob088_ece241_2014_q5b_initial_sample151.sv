module TopModule(
    input           clk,
    input           areset,
    input           x,
    output          z
);

reg [1:0] state, next_state;
wire      z_w;

// One-hot encoding for states
parameter A = 2'b01, B = 2'b10;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= A;
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case (state)
        A: begin
            if (x == 1'b0) begin
                next_state <= A;
                z_w <= 1'b0;
            end else begin
                next_state <= B;
                z_w <= 1'b1;
            end
        end
        B: begin
            if (x == 1'b0) begin
                next_state <= B;
                z_w <= 1'b1;
            end else begin
                next_state <= B;
                z_w <= 1'b0;
            end
        end
        default: begin
            next_state <= A;
            z_w <= 1'b0;
        end
    endcase
end

assign z = z_w;

endmodule