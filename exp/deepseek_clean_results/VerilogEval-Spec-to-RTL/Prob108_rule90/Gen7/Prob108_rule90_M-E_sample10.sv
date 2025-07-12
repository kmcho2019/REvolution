module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    reg [511:0] next_q;
    reg [8:0] counter;  // 512 positions (0-511)
    reg [2:0] shift_reg;  // [left, center, right]
    wire next_state;

    // XOR of neighbors (shift_reg[2] and shift_reg[0])
    assign next_state = shift_reg[2] ^ shift_reg[0];

    always @(posedge clk) begin
        if (load) begin
            q <= data;
            next_q <= data;
            counter <= 0;
        end else begin
            // Update shift register
            if (counter == 0) begin
                shift_reg <= {1'b0, q[0], q[1]};
            end else if (counter == 511) begin
                shift_reg <= {q[510], q[511], 1'b0};
            end else begin
                shift_reg <= {q[counter-1], q[counter], q[counter+1]};
            end

            // Update next state for current position
            next_q[counter] <= next_state;

            // Update counter
            counter <= (counter == 511) ? 0 : counter + 1;

            // Commit new state after full cycle
            if (counter == 511) begin
                q <= next_q;
            end
        end
    end

endmodule