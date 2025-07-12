module serial2parallel (
    input wire clk,
    input wire rst_n,
    input wire din_serial,
    input wire din_valid,
    output reg [7:0] dout_parallel,
    output wire dout_valid
);

    localparam IDLE    = 2'b00;
    localparam COLLECT = 2'b01;
    localparam DONE    = 2'b10;

    reg [1:0] state;
    reg [2:0] bit_cnt;
    reg [7:0] shift_reg;

    // Combinational output
    assign dout_valid = (state == DONE);

    // State transition logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (din_valid) begin
                        state <= COLLECT;
                    end
                end
                
                COLLECT: begin
                    if (bit_cnt == 3'd7 && din_valid) begin
                        state <= DONE;
                    end
                end
                
                DONE: begin
                    state <= IDLE;
                end
            endcase
        end
    end

    // Data processing logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            bit_cnt <= 3'b0;
            shift_reg <= 8'b0;
            dout_parallel <= 8'b0;
        end else begin
            case (state)
                IDLE: begin
                    bit_cnt <= 3'b0;
                    if (din_valid) begin
                        shift_reg <= {shift_reg[6:0], din_serial};
                        bit_cnt <= bit_cnt + 1'b1;
                    end
                end
                
                COLLECT: begin
                    if (din_valid) begin
                        shift_reg <= {shift_reg[6:0], din_serial};
                        bit_cnt <= bit_cnt + 1'b1;
                        
                        if (bit_cnt == 3'd7) begin
                            dout_parallel <= {shift_reg[6:0], din_serial};
                        end
                    end
                end
                
                DONE: begin
                    // No operation, outputs remain stable
                end
            endcase
        end
    end

endmodule