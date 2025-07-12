module serial2parallel #(
    parameter WIDTH = 8
) (
    input wire clk,
    input wire rst_n,
    input wire din_serial,
    input wire din_valid,
    output reg [WIDTH-1:0] dout_parallel,
    output wire dout_valid
);

    reg [WIDTH-1:0] buffer;
    reg [$clog2(WIDTH)-1:0] bit_count;
    reg state;
    reg valid_pulse;

    localparam COLLECT = 1'b0;
    localparam OUTPUT  = 1'b1;

    assign dout_valid = valid_pulse;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            buffer <= {WIDTH{1'b0}};
            dout_parallel <= {WIDTH{1'b0}};
            bit_count <= '0;
            valid_pulse <= 1'b0;
            state <= COLLECT;
        end
        else begin
            valid_pulse <= 1'b0;  // Default low

            case (state)
                COLLECT: begin
                    if (din_valid) begin
                        buffer <= {buffer[WIDTH-2:0], din_serial};
                        
                        if (bit_count == WIDTH-1) begin
                            dout_parallel <= {buffer[WIDTH-2:0], din_serial};
                            valid_pulse <= 1'b1;
                            bit_count <= '0;
                            // Stay in COLLECT state for continuous operation
                        end
                        else begin
                            bit_count <= bit_count + 1'b1;
                        end
                    end
                end

                // OUTPUT state removed as we handle output immediately in COLLECT
            endcase
        end
    end

endmodule