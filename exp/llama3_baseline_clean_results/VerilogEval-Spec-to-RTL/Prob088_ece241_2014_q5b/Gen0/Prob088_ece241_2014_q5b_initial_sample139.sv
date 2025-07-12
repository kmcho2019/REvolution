module TopModule(
    input clk,
    input areset,
    input x,
    output z
);

// Define states
parameter A = 2'b01;
parameter B = 2'b10;

// Declare current state register
reg [1:0] current_state;
reg [1:0] next_state;

// Combinational logic to determine next state and output
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

// Sequential logic to update current state
always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= A;
    end else begin
        current_state <= next_state;
    end
end

endmodule