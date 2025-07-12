module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output reg valid_out,
    output reg dout
);

    reg [3:0] state;    // One-hot state (0001, 0010, 0100, 1000)
    reg [3:0] data;     // Data storage (no shifting needed)

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset condition
            state <= 4'b0001;
            data <= 4'b0;
            dout <= 1'b0;
            valid_out <= 1'b0;
        end else begin
            case (state)
                4'b0001: begin
                    // First state - load new data
                    data <= d;
                    dout <= d[3];
                    valid_out <= 1'b1;
                    state <= 4'b0010;
                end
                4'b0010: begin
                    // Second state
                    dout <= data[2];
                    valid_out <= 1'b0;
                    state <= 4'b0100;
                end
                4'b0100: begin
                    // Third state
                    dout <= data[1];
                    valid_out <= 1'b0;
                    state <= 4'b1000;
                end
                4'b1000: begin
                    // Fourth state
                    dout <= data[0];
                    valid_out <= 1'b0;
                    state <= 4'b0001;
                end
                default: begin
                    // Should never happen
                    state <= 4'b0001;
                end
            endcase
        end
    end

endmodule