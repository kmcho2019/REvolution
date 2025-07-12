module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output wire valid_out,
    output wire dout
);

    reg [3:0] state;    // One-hot state (0001, 0010, 0100, 1000)
    reg [3:0] data;     // Shift register

    assign dout = data[3];
    assign valid_out = state[0];  // Valid only in first state

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= 4'b0001;
            data <= 4'b0;
        end else begin
            // State transition (circular shift)
            state <= {state[2:0], state[3]};
            
            // Data handling - load new data or shift
            if (state[3]) begin  // Last state - load new data
                data <= d;
            end else if (!state[0]) begin  // Shift states only
                data <= {data[2:0], 1'b0};
            end
        end
    end

endmodule