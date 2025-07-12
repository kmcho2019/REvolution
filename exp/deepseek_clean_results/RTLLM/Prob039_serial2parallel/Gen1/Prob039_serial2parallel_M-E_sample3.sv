module serial2parallel (
    input wire clk,
    input wire rst_n,
    input wire din_serial,
    input wire din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

    reg [2:0] cnt;  // bit position counter (0-7)
    reg state;      // 0: COLLECT, 1: OUTPUT

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 3'b0;
            dout_parallel <= 8'b0;
            dout_valid <= 1'b0;
            state <= 1'b0;
        end
        else begin
            case (state)
                1'b0: begin // COLLECT state
                    if (din_valid) begin
                        // Direct assignment to current bit position
                        dout_parallel[7-cnt] <= din_serial;
                        
                        if (cnt == 3'd7) begin
                            state <= 1'b1;  // transition to OUTPUT
                            dout_valid <= 1'b1;
                            cnt <= 3'b0;
                        end
                        else begin
                            cnt <= cnt + 1'b1;
                        end
                    end
                    dout_valid <= 1'b0;
                end
                
                1'b1: begin // OUTPUT state
                    state <= 1'b0;  // always return to COLLECT
                    dout_valid <= 1'b0;
                    
                    // Pre-load first bit if valid
                    if (din_valid) begin
                        dout_parallel[7] <= din_serial;
                        cnt <= 3'd1;
                    end
                end
            endcase
        end
    end

endmodule