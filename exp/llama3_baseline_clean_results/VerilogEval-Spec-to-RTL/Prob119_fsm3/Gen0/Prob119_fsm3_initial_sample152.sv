module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

// Define states
parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;
parameter D = 2'b11;

reg [1:0] current_state;
reg [1:0] next_state;

// Assign output based on current state
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
            if (!in) begin
                next_state = A;
            end else begin
                next_state = B;
            end
        end
        B: begin
            if (!in) begin
                next_state = C;
            end else begin
                next_state = B;
            end
        end
        C: begin
            if (!in) begin
                next_state = A;
            end else begin
                next_state = D;
            end
        end
        D: begin
            if (!in) begin
                next_state = C;
            end else begin
                next_state = B;
            end
        end
        default: next_state = A;
    endcase
end

// Assign output based on current state
assign out = (current_state == D) ? 1'b1 : 1'b0;

endmodule