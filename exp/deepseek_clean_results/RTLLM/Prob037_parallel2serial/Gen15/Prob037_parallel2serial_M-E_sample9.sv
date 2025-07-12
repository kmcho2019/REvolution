module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output reg valid_out,
    output reg dout
);

    reg [1:0] ptr;      // 2-bit pointer (0-3)
    reg [3:0] buffer;   // Circular buffer storage

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            ptr <= 2'b00;
            buffer <= 4'b0000;
            dout <= 1'b0;
            valid_out <= 1'b0;
        end else begin
            // Update pointer with wrap-around
            ptr <= (ptr == 2'b11) ? 2'b00 : ptr + 1;

            // Load new data when pointer wraps
            if (ptr == 2'b11) begin
                buffer <= d;
                valid_out <= 1'b1;
            end else begin
                valid_out <= 1'b0;
            end

            // Output current bit based on pointer
            case (ptr)
                2'b00: dout <= buffer[3];
                2'b01: dout <= buffer[2];
                2'b10: dout <= buffer[1];
                2'b11: dout <= buffer[0];
            endcase
        end
    end

endmodule