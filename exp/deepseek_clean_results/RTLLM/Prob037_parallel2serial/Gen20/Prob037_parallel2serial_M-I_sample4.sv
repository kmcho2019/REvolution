module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output reg valid_out,
    output reg dout
);

    reg [3:0] state;  // One-hot state: 0001, 0010, 0100, 1000
    reg [3:0] data_reg;
    wire enable = rst_n;  // Clock enable when not in reset

    // State machine and data handling
    always @(posedge clk) begin
        if (!rst_n) begin
            state <= 4'b0001;
            data_reg <= 4'b0;
            valid_out <= 1'b0;
            dout <= 1'b0;
        end else if (enable) begin
            // State transition
            state <= {state[2:0], state[3]};
            
            // Data handling
            if (state[3]) begin  // Last state - load new data
                data_reg <= d;
                valid_out <= 1'b1;
            end else begin
                valid_out <= 1'b0;
            end
            
            // Output pipeline
            dout <= data_reg[3];
            
            // Shift data
            if (!state[3]) begin
                data_reg <= {data_reg[2:0], 1'b0};
            end
        end
    end

endmodule