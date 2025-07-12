module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg phase;  // 0 = up phase, 1 = down phase
reg [4:0] up_counter;
reg [4:0] down_counter;

// Counter updates
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        up_counter <= 5'b0;
        down_counter <= 5'b11111;
        phase <= 1'b0;
    end else begin
        // Up counter (0→31)
        if (!phase) begin
            up_counter <= up_counter + 1'b1;
            if (&up_counter) phase <= 1'b1;
        end
        
        // Down counter (31→0)
        if (phase) begin
            down_counter <= down_counter - 1'b1;
            if (down_counter == 5'b0) phase <= 1'b0;
        end
    end
end

// Output selection
always @(*) begin
    wave = phase ? down_counter : up_counter;
end

endmodule