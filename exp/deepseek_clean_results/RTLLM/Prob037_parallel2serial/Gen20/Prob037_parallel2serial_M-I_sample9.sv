module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output wire valid_out,
    output wire dout
);

    reg [1:0] cnt;          // Binary counter (0-3)
    reg [2:0] data_reg;     // Stores bits [2:0] of current word
    reg current_msb;        // Stores MSB of current word

    // Counter update logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 2'b00;
        end else begin
            cnt <= (cnt == 2'b11) ? 2'b00 : cnt + 1;
        end
    end

    // Data register update logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_msb <= 1'b0;
            data_reg <= 3'b000;
        end else if (cnt == 2'b11) begin
            // Load new data at end of cycle
            current_msb <= d[3];
            data_reg <= d[2:0];
        end
    end

    // Barrel shifter for output selection
    assign dout = (cnt == 2'b00) ? current_msb :
                 (cnt == 2'b01) ? data_reg[2] :
                 (cnt == 2'b10) ? data_reg[1] :
                 data_reg[0];

    // Valid out is high when counter is 0 (first bit of new word)
    assign valid_out = (cnt == 2'b00);

endmodule