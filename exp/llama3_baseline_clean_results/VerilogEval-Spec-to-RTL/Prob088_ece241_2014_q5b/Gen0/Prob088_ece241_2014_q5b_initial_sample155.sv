module TopModule(
    input  clk,
    input  areset,
    input  x,
    output z
);

// One-hot encoding for states
reg [1:0] current_state;
reg [1:0] next_state;

// Define the states
parameter A = 2'b01;
parameter B = 2'b10;

always @(posedge clk or posedge areset) begin
    if(areset) begin
        current_state <= A;
    end else begin
        current_state <= next_state;
    end
end

always @(*) begin
    case(current_state)
        A: begin
            if(x) begin
                next_state = B;
                z = 1'b1;
            end else begin
                next_state = A;
                z = 1'b0;
            end
        end
        B: begin
            next_state = B;
            if(x) begin
                z = 1'b0;
            end else begin
                z = 1'b1;
            end
        end
        default: begin
            next_state = A;
            z = 1'b0;
        end
    endcase
end

endmodule