module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output reg valid_out,
    output reg dout
);

    reg [1:0] cnt_gray;      // Gray code counter (00,01,11,10)
    reg [3:0] data;         // Data register
    wire [1:0] cnt_binary;  // Binary equivalent for mux select

    // Gray to binary conversion
    assign cnt_binary[1] = cnt_gray[1];
    assign cnt_binary[0] = cnt_gray[1] ^ cnt_gray[0];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset condition
            cnt_gray <= 2'b00;
            data <= 4'b0;
            valid_out <= 1'b0;
            dout <= 1'b0;
        end else begin
            // Gray code counter increment
            case (cnt_gray)
                2'b00: cnt_gray <= 2'b01;
                2'b01: cnt_gray <= 2'b11;
                2'b11: cnt_gray <= 2'b10;
                2'b10: begin
                    cnt_gray <= 2'b00;
                    data <= d;  // Load new data
                end
            endcase

            // Generate valid_out pulse (single cycle)
            valid_out <= (cnt_gray == 2'b10);

            // Mux-based bit selection
            case (cnt_binary)
                2'b00: dout <= data[3];
                2'b01: dout <= data[2];
                2'b10: dout <= data[1];
                2'b11: dout <= data[0];
            endcase
        end
    end

endmodule