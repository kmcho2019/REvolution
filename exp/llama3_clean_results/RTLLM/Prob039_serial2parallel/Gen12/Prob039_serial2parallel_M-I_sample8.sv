module serial2parallel (
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

reg [3:0] cnt;
reg [1:0] state;
localparam IDLE = 2'b00;
localparam CONVERTING = 2'b01;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= IDLE;
        cnt <= 4'b0000;
        dout_parallel <= 8'b00000000;
        dout_valid <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                if (din_valid) begin
                    state <= CONVERTING;
                    cnt <= 4'b0001;
                    dout_parallel <= {7'b0000000, din_serial};
                    dout_valid <= 1'b0;
                end
            end
            CONVERTING: begin
                if (din_valid && cnt < 4'b1000) begin
                    cnt <= cnt + 1'b1;
                    dout_parallel <= {dout_parallel[6:0], din_serial};
                end else if (cnt == 4'b1000) begin
                    state <= IDLE;
                    dout_valid <= 1'b1;
                end else begin
                    state <= IDLE;
                    cnt <= 4'b0000;
                    dout_valid <= 1'b0;
                end
            end
        endcase
    end
end

// Additional logic to reduce power consumption by minimizing unnecessary switching
always @(posedge clk) begin
    if (state == IDLE && din_valid) begin
        // Only update counter and output when necessary
        cnt <= cnt + 1'b1;
    end else if (state == CONVERTING && cnt == 4'b1000) begin
        // Reset counter when conversion is complete
        cnt <= 4'b0000;
    end
end

endmodule