module TopModule(
    input  clk,
    input  areset,
    input  x,
    output z
);

reg [1:0] current_state;
reg [1:0] next_state;

// One-hot encoding: A = 2'b01, B = 2'b10
localparam A = 2'b01;
localparam B = 2'b10;

// Combinatorial logic for next state and output
always @(*) begin
    case (current_state)
        A: begin
            if (~x) begin
                next_state = A;
                z = 1'b0;
            end else begin
                next_state = B;
                z = 1'b1;
            end
        end
        B: begin
            next_state = B;
            if (~x) begin
                z = 1'b1;
            end else begin
                z = 1'b0;
            end
        end
        default: begin
            next_state = A;
            z = 1'b0;
        end
    endcase
end

// Sequential logic for current state update
always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= A;
    end else begin
        current_state <= next_state;
    end
end

endmodule