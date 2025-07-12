module square_wave (
    input clk,
    input [7:0] freq,
    output wave_out
);

    reg [7:0] count;
    reg toggle_flag;
    wire counter_enable = (freq != 0);
    wire counter_done = (count == 0) & counter_enable;
    
    // Optimized output generation
    assign wave_out = counter_enable ? toggle_flag : 1'b0;
    
    // Efficient counter control
    always @(posedge clk) begin
        if (counter_enable) begin
            if (counter_done) begin
                toggle_flag <= ~toggle_flag;
                count <= freq - 1;  // Reload with (freq-1) for precise counting
            end else begin
                count <= count - 1;  // Efficient down-counting
            end
        end
    end

    // Initialization (optional for FPGA)
    initial begin
        count = 0;
        toggle_flag = 0;
    end

endmodule