module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output wire valid_out,
    output wire dout
);

    reg [3:0] state = 4'b0001;  // One-hot state
    reg [3:0] data_reg;

    // State and data register update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= 4'b0001;
            data_reg <= 4'b0;
        end else begin
            // Rotate state left circular
            state <= {state[2:0], state[3]};
            
            // Load new data when state wraps around
            if (state[3]) begin
                data_reg <= d;
            end
        end
    end

    // Output logic
    assign valid_out = state[0];  // Valid when starting new conversion
    assign dout = (data_reg[3] & state[0]) |  // Bit 3 when state[0]
                  (data_reg[2] & state[1]) |  // Bit 2 when state[1]
                  (data_reg[1] & state[2]) |  // Bit 1 when state[2]
                  (data_reg[0] & state[3]);   // Bit 0 when state[3]

endmodule