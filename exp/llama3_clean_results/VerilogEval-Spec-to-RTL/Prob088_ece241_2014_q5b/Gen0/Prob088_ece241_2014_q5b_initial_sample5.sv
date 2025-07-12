module TopModule(
    input  clk,
    input  areset,
    input  x,
    output z
);

reg [1:0] current_state;
reg [1:0] next_state;

// One-hot encoding for states
parameter A = 2'b01;
parameter B = 2'b10;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= A;
    end else begin
        current_state <= next_state;
    end
end

always @(*) begin
    case (current_state)
        A: begin
            if (x == 0) begin
                next_state <= A;
                z <= 0;
            end else begin
                next_state <= B;
                z <= 1;
            end
        end
        B: begin
            if (x == 0) begin
                next_state <= B;
                z <= 1;
            end else begin
                next_state <= B;
                z <= 0;
            end
        end
        default: begin
            next_state <= A;
            z <= 0;
        end
    endcase
end

endmodule