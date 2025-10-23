module serial2parallel (
    input wire clk,
    input wire rst_n,
    input wire din_serial,
    input wire din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

    localparam IDLE   = 2'b00;
    localparam COLLECT = 2'b01;
    localparam READY   = 2'b10;
    localparam OUTPUT = 2'b11;

    reg [1:0] state;
    reg [2:0] bit_cnt;
    reg [7:0] data_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            bit_cnt <= 3'b0;
            data_reg <= 8'b0;
            dout_parallel <= 8'b0;
            dout_valid <= 1'b0;
        end
        else begin
            case (state)
                IDLE: begin
                    dout_valid <= 1'b0;
                    if (din_valid) begin
                        data_reg <= {data_reg[6:0], din_serial};
                        bit_cnt <= 3'b1;
                        state <= COLLECT;
                    end
                end
                
                COLLECT: begin
                    if (din_valid) begin
                        if (bit_cnt == 3'd7) begin
                            dout_parallel <= {data_reg[6:0], din_serial};
                            state <= READY;
                        end
                        else begin
                            data_reg <= {data_reg[6:0], din_serial};
                            bit_cnt <= bit_cnt + 1'b1;
                        end
                    end
                end
                
                READY: begin
                    dout_valid <= 1'b1;
                    state <= OUTPUT;
                end
                
                OUTPUT: begin
                    dout_valid <= 1'b0;
                    if (din_valid) begin
                        data_reg <= {7'b0, din_serial};
                        bit_cnt <= 3'b1;
                        state <= COLLECT;
                    end
                    else begin
                        state <= IDLE;
                    end
                end
            endcase
        end
    end

endmodule