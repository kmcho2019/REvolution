module serial2parallel (
    input wire clk,
    input wire rst_n,
    input wire din_serial,
    input wire din_valid,
    output reg [7:0] dout_parallel,
    output wire dout_valid
);

    reg [2:0] bit_count;
    reg [7:0] shift_reg;
    wire parallel_load;

    // Counter logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            bit_count <= 3'd0;
        end
        else if (din_valid) begin
            if (parallel_load) begin
                bit_count <= 3'd0;
            end
            else begin
                bit_count <= bit_count + 1'b1;
            end
        end
    end

    // Shift register logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift_reg <= 8'b0;
        end
        else if (din_valid) begin
            shift_reg <= {shift_reg[6:0], din_serial};
        end
    end

    // Parallel output register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            dout_parallel <= 8'b0;
        end
        else if (parallel_load) begin
            dout_parallel <= {shift_reg[6:0], din_serial};
        end
    end

    // Combinational outputs
    assign parallel_load = (bit_count == 3'd7) & din_valid;
    assign dout_valid = parallel_load;

endmodule