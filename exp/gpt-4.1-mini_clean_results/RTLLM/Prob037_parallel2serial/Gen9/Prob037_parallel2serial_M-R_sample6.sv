module parallel2serial (
    input        clk,
    input        rst_n,
    input  [3:0] d,
    output       valid_out,
    output       dout
);

    typedef enum logic [0:0] {
        LOAD  = 1'b0,
        SHIFT = 1'b1
    } state_t;

    reg [3:0] data_reg;
    reg [1:0] cnt;
    reg       valid_reg;
    reg       state;

    // State register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state     <= LOAD;
            cnt       <= 2'd0;
            data_reg  <= 4'b0;
            valid_reg <= 1'b0;
        end else begin
            case (state)
                LOAD: begin
                    data_reg  <= d;
                    valid_reg <= 1'b1;
                    cnt       <= 2'd0;
                    state     <= SHIFT;
                end
                SHIFT: begin
                    valid_reg <= 1'b0;
                    data_reg  <= {data_reg[2:0], 1'b0};
                    cnt       <= cnt + 1'b1;
                    if (cnt == 2'd3) begin
                        state <= LOAD;
                    end
                end
                default: begin
                    state <= LOAD;
                    valid_reg <= 1'b0;
                    cnt <= 2'd0;
                    data_reg <= 4'b0;
                end
            endcase
        end
    end

    assign dout      = data_reg[3];
    assign valid_out = valid_reg;

endmodule