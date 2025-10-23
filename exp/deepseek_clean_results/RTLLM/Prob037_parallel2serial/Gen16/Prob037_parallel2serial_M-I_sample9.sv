module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output wire valid_out,
    output wire dout
);

    reg [3:0] state;    // One-hot counter (0001, 0010, 0100, 1000)
    reg [3:0] data;     // Combined input/shift register

    assign dout = data[3];
    assign valid_out = state[0];  // First cycle is always valid

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= 4'b0001;
            data <= 4'b0;
        end else begin
            // State transition (circular shift)
            state <= {state[2:0], state[3]};
            
            // Data handling - only update when needed
            if (state[3]) begin  // Load new data on last cycle
                data <= d;
            end else if (|state[2:0]) begin  // Shift only when needed
                data <= {data[2:0], 1'b0};
            end
        end
    end

endmodule