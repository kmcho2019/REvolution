module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output wire valid_out,
    output wire dout
);

    reg [3:0] state;        // One-hot state (4 states)
    reg [3:0] data_reg;     // Data register

    // Output assignments
    assign dout = data_reg[3];
    assign valid_out = state[0];  // Valid on first state

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= 4'b0001;  // Initialize to first state
            data_reg <= 4'b0;
        end else begin
            if (state[3]) begin
                // Last state - load new data and reset
                state <= 4'b0001;
                data_reg <= d;
            end else begin
                // Rotate state and shift data
                state <= {state[2:0], state[3]};
                data_reg <= {data_reg[2:0], 1'b0};
            end
        end
    end

endmodule