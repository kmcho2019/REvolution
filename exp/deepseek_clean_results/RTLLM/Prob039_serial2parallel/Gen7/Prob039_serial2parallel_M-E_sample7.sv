module serial2parallel (
    input wire clk,
    input wire rst_n,
    input wire din_serial,
    input wire din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

    // FSM states
    localparam IDLE  = 1'b0;
    localparam COLLECT = 1'b1;
    
    reg state;
    reg [2:0] bit_counter;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            bit_counter <= 3'b0;
            dout_parallel <= 8'b0;
            dout_valid <= 1'b0;
        end
        else begin
            dout_valid <= 1'b0; // Default
            
            case (state)
                IDLE: begin
                    if (din_valid) begin
                        dout_parallel <= {7'b0, din_serial}; // Initialize with first bit
                        bit_counter <= 3'b1;
                        state <= COLLECT;
                    end
                end
                
                COLLECT: begin
                    if (din_valid) begin
                        dout_parallel <= {dout_parallel[6:0], din_serial};
                        
                        if (bit_counter == 3'd7) begin
                            dout_valid <= 1'b1;
                            state <= IDLE;
                        end
                        else begin
                            bit_counter <= bit_counter + 1;
                        end
                    end
                end
            endcase
        end
    end

endmodule