module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output wire valid_out,
    output wire dout
);

    // One-hot state encoding (4 states)
    reg [3:0] state;
    reg [3:0] data_reg;

    // Next state logic (one-hot rotation)
    wire [3:0] next_state = {state[2:0], state[3]};

    // Output selection
    assign dout = (state[0] ? data_reg[3] :
                  state[1] ? data_reg[2] :
                  state[2] ? data_reg[1] :
                             data_reg[0]);

    // Valid when in first state
    assign valid_out = state[0];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= 4'b0001;  // Initialize to first state
            data_reg <= 4'b0;
        end else begin
            state <= next_state;
            if (state[3]) begin  // Load new data when in last state
                data_reg <= d;
            end
        end
    end

endmodule