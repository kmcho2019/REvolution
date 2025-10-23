module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output reg valid_out,
    output reg dout
);

    reg [1:0] ptr;      // 2-bit pointer (0-3)
    reg [3:0] data_reg; // Data storage register
    reg load_new;       // Control signal for loading new data

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset condition
            ptr <= 2'b0;
            data_reg <= 4'b0;
            valid_out <= 1'b0;
            dout <= 1'b0;
            load_new <= 1'b1;
        end else begin
            // Pointer logic
            if (ptr == 2'b11) begin
                ptr <= 2'b0;
                load_new <= 1'b1;
            end else begin
                ptr <= ptr + 1'b1;
                load_new <= 1'b0;
            end

            // Data loading and output
            if (load_new) begin
                data_reg <= d;
                valid_out <= 1'b1;
                dout <= d[3];  // Output MSB when loading new data
            end else begin
                valid_out <= 1'b0;
                // Output based on current pointer position
                case (ptr)
                    2'b00: dout <= data_reg[2];
                    2'b01: dout <= data_reg[1];
                    2'b10: dout <= data_reg[0];
                    default: dout <= 1'b0;
                endcase
            end
        end
    end

endmodule