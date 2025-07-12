module TopModule(
    input clk,
    input a,
    output q
);

reg q_reg;
reg [1:0] state;

always @(posedge clk) begin
    if (a) begin
        if (state == 2'b01) begin // If the previous state was 01 (indicating a '1' was detected)
            state <= 2'b10; // Change state to 10, indicating 'q' should go low
            q_reg <= 1'b0; // Set q_reg to 0
        end else if (state == 2'b00) begin // If the previous state was 00
            state <= 2'b01; // Change state to 01, indicating a '1' was detected
        end else if (state == 2'b10) begin // If the previous state was 10
            state <= 2'b10; // Remain in state 10
        end
    end else begin // If 'a' is 0
        if (state == 2'b10) begin // If the current state is 10 (q is low)
            state <= 2'b00; // Reset state to 00, preparing for a new sequence
            q_reg <= 1'b1; // Set q_reg high
        end else begin // If 'a' is 0 and state is not 10
            state <= 2'b00; // Remain in or transition to state 00
        end
    end
end

assign q = q_reg;

initial begin
    q_reg = 1'b1;
    state = 2'b00;
end

endmodule