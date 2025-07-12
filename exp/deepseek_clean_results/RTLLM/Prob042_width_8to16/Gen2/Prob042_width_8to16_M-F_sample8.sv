module width_8to16 (
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire [7:0] data_in,
    output reg valid_out,
    output reg [15:0] data_out
);

reg [7:0] data_lock;  // Temporary storage for first byte
reg state;            // 0: waiting first byte, 1: waiting second byte

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Active-low reset
        data_lock <= 8'b0;
        state <= 1'b0;
        valid_out <= 1'b0;
        data_out <= 16'b0;
    end else begin
        // Reset valid_out unless we're outputting data
        valid_out <= 1'b0;
        
        if (valid_in) begin
            case (state)
                1'b0: begin
                    // First valid input - store it
                    data_lock <= data_in;
                    state <= 1'b1;
                end
                1'b1: begin
                    // Second valid input - concatenate and output
                    data_out <= {data_lock, data_in};
                    valid_out <= 1'b1;
                    state <= 1'b0;
                end
            endcase
        end
    end
end

endmodule