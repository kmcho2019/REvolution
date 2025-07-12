module TopModule(
    input clk,
    input areset,
    input x,
    output z
);

// One-hot encoding for states
reg [1:0] state;
reg [1:0] next_state;

// Define states
localparam A = 2'b10;
localparam B = 2'b01;

always @(*) begin
    case (state)
        A: begin
            if (x == 0) begin
                next_state = A;
                z = 0;
            end
            else begin
                next_state = B;
                z = 1;
            end
        end
        B: begin
            if (x == 0) begin
                next_state = B;
                z = 1;
            end
            else begin
                next_state = B;
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
    end
    else begin
        state <= next_state;
    end
end

endmodule