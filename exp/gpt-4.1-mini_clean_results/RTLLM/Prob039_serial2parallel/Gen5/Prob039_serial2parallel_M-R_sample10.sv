module serial2parallel (
    input        clk,
    input        rst_n,
    input        din_serial,
    input        din_valid,
    output reg [7:0] dout_parallel,
    output reg       dout_valid
);

    localparam IDLE = 1'b0;
    localparam LOAD = 1'b1;

    reg state, next_state;
    reg [7:0] shift_reg;
    reg [3:0] cnt;

    // State transition logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE:
                if (din_valid)
                    next_state = LOAD;
                else
                    next_state = IDLE;
            LOAD:
                if (din_valid && cnt == 4'd7)
                    next_state = IDLE;
                else
                    next_state = LOAD;
            default:
                next_state = IDLE;
        endcase
    end

    // Data path and counter
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift_reg    <= 8'd0;
            cnt          <= 4'd0;
            dout_parallel <= 8'd0;
            dout_valid   <= 1'b0;
        end else begin
            dout_valid <= 1'b0; // default

            case (state)
                IDLE: begin
                    cnt <= 4'd0;
                    if (din_valid) begin
                        shift_reg <= {shift_reg[6:0], din_serial};
                        cnt <= 4'd1;
                    end
                end
                LOAD: begin
                    if (din_valid) begin
                        shift_reg <= {shift_reg[6:0], din_serial};
                        if (cnt == 4'd7) begin
                            dout_parallel <= {shift_reg[6:0], din_serial};
                            dout_valid <= 1'b1;
                            cnt <= 4'd0;
                        end else begin
                            cnt <= cnt + 1;
                        end
                    end
                end
            endcase
        end
    end

endmodule