module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

// One-hot encoded states: A and B
reg A;
reg B;

// Initialize the states
initial begin
    A = 1'b1;
    B = 1'b0;
end

// Asynchronous reset
always @(posedge clk or posedge areset) begin
    if (areset) begin
        A <= 1'b1;
        B <= 1'b0;
    end else begin
        // State transitions
        if (A) begin
            if (x) begin
                A <= 1'b0;
                B <= 1'b1;
            end else begin
                A <= 1'b1;
                B <= 1'b0;
            end
        end else if (B) begin
            A <= 1'b0;
            B <= 1'b1;
        end
    end
end

// Output 'z' logic
assign z = (A && x) || (B && ~x);

endmodule