module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output z
);

reg [1:0] state;

// Asynchronous reset
always @(negedge aresetn or posedge clk) begin
    if (!aresetn) begin
        state <= 2'b00; // idle state
    end else begin
        case (state)
            2'b00: begin // idle state
                if (x) begin
                    state <= 2'b01; // seq_1
                end else begin
                    state <= 2'b00; // stay in idle
                end
            end
            2'b01: begin // seq_1
                if (!x) begin
                    state <= 2'b10; // seq_10
                end else begin
                    state <= 2'b01; // stay in seq_1
                end
            end
            2'b10: begin // seq_10
                if (x) begin
                    state <= 2'b11; // seq_101
                end else begin
                    state <= 2'b01; // go back to seq_1
                end
            end
            2'b11: begin // seq_101
                if (x) begin
                    state <= 2'b11; // stay in seq_101
                end else begin
                    state <= 2'b01; // go back to seq_1
                end
            end
        endcase
    end
end

// Output logic
assign z = (state == 2'b11); // output 1 when in seq_101 state

endmodule