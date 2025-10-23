module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

// Define states
parameter A = 2'b01;
parameter B = 2'b10;

// State register
reg [1:0] current_state;

// Output z
reg z;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= A;
    end else begin
        case (current_state)
            A: begin
                if (x == 1'b0) begin
                    current_state <= A;
                    z <= 1'b0;
                end else begin
                    current_state <= B;
                    z <= 1'b1;
                end
            end
            B: begin
                if (x == 1'b0) begin
                    current_state <= B;
                    z <= 1'b1;
                end else begin
                    current_state <= B;
                    z <= 1'b0;
                end
            end
            default: begin
                current_state <= A;
                z <= 1'b0;
            end
        endcase
    end
end

endmodule