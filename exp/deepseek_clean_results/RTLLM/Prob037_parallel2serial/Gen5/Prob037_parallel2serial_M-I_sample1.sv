module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output reg valid_out,
    output reg dout
);

    reg [3:0] data;       // Data storage register
    reg [3:0] state;      // One-hot state (bit0: bit0, bit1: bit1, etc.)
    wire last_bit = state[3];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset condition
            data <= 4'b0;
            state <= 4'b0001;  // Start at bit0
            valid_out <= 1'b0;
            dout <= 1'b0;
        end else begin
            if (last_bit) begin
                // Last bit - load new data
                data <= d;
                state <= 4'b0001;  // Back to bit0
                valid_out <= 1'b1;
                dout <= d[3];      // Output MSB
            end else begin
                // Next state
                state <= {state[2:0], 1'b0};
                valid_out <= 1'b0;
                // Output current bit based on state
                case (state)
                    4'b0001: dout <= data[3];
                    4'b0010: dout <= data[2];
                    4'b0100: dout <= data[1];
                    4'b1000: dout <= data[0];
                    default: dout <= 1'b0;
                endcase
            end
        end
    end

endmodule